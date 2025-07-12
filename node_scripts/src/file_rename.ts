import { argv } from 'node:process';
import { rename } from 'node:fs/promises';
import { glob } from 'glob';
import path from 'path';
import readline from 'node:readline/promises';

//files to rename pattern: google_material_icons/**/*.png
//filename match pattern example: (.*)\_24dp_FFFFFF.*.png
//replace pattern example: spr_icon_$1
//file pattern
const filePattern = argv[2];
const newNamePattern = argv[3];
const replacePattern = argv[4];

console.log(`\nfilePattern: ${filePattern} \nnewNamePattern: ${newNamePattern}\nreplacePattern: ${replacePattern}\n`);

const regexPattern = new RegExp(newNamePattern);
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

await glob(filePattern).then(async (files) => {

    const proposedChanges: [string, string][] = [];

    for(const filename of files) {
        //filePattern
        const baseFilename = path.basename(filename);
        const renamedFilename = baseFilename.replace(regexPattern, replacePattern);
        const filepath = path.dirname(filename);
        const newPath = path.join(filepath, renamedFilename);
        console.log(`Renaming ${filename} to ${newPath}`);
        proposedChanges.push([filename, newPath]);
    }

    const answer = await rl.question(`Make changes?`);
    const matchesYes = !!answer.match(/^(Y|y|(yes)|(Yes))$/);
    if(matchesYes) {
        console.log("...Making changes");
        for(const [oldPath, newPath] of proposedChanges) {
            await rename(oldPath, newPath);
        }
    }
    rl.close();
});