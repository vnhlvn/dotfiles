import { $ } from 'bun';
import Handlebars from 'handlebars';

const MAIN_GITCONFIG = `${process.env.HOME}/.gitconfig`;
const WORK_GITCONFIG = `${process.env.HOME}/.gitconfig.work`;
const PERSONAL_GITCONFIG = `${process.env.HOME}/.gitconfig.personal`;

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
	gpgSshProgram: '/Applications/1Password.app/Contents/MacOS/op-ssh-sign' 
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

await $`touch .gitconfig`;
await $`echo ${personalTemplateCompiled} > ${Bun.file('.gitconfig')}`;

await $`touch .gitconfig.work`;
await $`echo ${workTemplateCompiled} >> .gitconfig.work`;

await $`touch .gitconfig.main`;
await $`echo ${mainTemplateCompiled} >> .gitconfig.main`;

