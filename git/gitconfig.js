import { readdir, mkdir } from "node:fs/promises";
import { $ } from 'bun';
import Handlebars from 'handlebars';

const gpgPrograms = {
	'linux': '/opt/1Password/op-ssh-sign',
	'darwin': '/Applications/1Password.app/Contents/MacOS/op-ssh-sign' 
}

const personalGitConfig = {
	firstName: await $`op read  "op://Personal/Personal Identity/Identification/first name" -n`.text(),
	lastName: await $`op read  "op://Personal/Personal Identity/Identification/last name" -n`.text(),
	email: await $`op read "op://Personal/Personal Identity/Internet Details/email" -n`.text(),
	publicKey: await $`op read  "op://Personal/Personal SSH Key/public key" -n`.text(),
};

const workGitConfig = {
	firstName: await $`op read  "op://Work/Amplify Identity/Identification/first name" -n`.text(),
	lastName: await $`op read  "op://Work/Amplify Identity/Identification/last name" -n`.text(),
	email: await $`op read "op://Work/Amplify Identity/Identification/email" -n`.text(),
	publicKey: await $`op read  "op://Work/Work SSH Key/public key" -n`.text(),
};

const mainGitConfig = {
	gpgSshProgram: gpgPrograms[process.platform] 
};

async function readTemplate(path) {
	return await $`cat ${path}`.text();
}

const personalTemplate = await readTemplate('./personal.hbs');
const workTemplate = await readTemplate('./work.hbs');
const mainTemplate = await readTemplate('./gitconfig.hbs');

const personalTemplateCompiled = Handlebars.compile(personalTemplate)(personalGitConfig);
const workTemplateCompiled = Handlebars.compile(workTemplate)(workGitConfig);
const mainTemplateCompiled = Handlebars.compile(mainTemplate)(mainGitConfig);

try {
	const files = await readdir('./dist')
		if (files.length > 0) {
			await $`rm -rf .gitconfig .gitconfig.personal .gitconfig.work`.cwd('./dist');
		}
} catch (error) {
	console.log('Caught error:', error);
	if (error.code === 'ENOENT') {
		await mkdir('./dist');
	}
}

await $`echo ${mainTemplateCompiled} > './dist/.gitconfig'`;
await $`echo ${workTemplateCompiled} > ./dist/.gitconfig.work`;
await $`echo ${personalTemplateCompiled} > ./dist/.gitconfig.personal`;

