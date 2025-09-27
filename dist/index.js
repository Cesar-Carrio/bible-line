#!/usr/bin/env node
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
const colors_1 = __importDefault(require("colors"));
// Import bible data with proper typing
const bibleDataPath = path.join(__dirname, 'data', 'bibleChapters.json');
const bibleData = JSON.parse(fs.readFileSync(bibleDataPath, 'utf8'));
const version = 'en-kjv';
// Command line argument handling
const args = process.argv.slice(2);
const helpFlag = args.includes('--help') || args.includes('-h');
const versionFlag = args.includes('--version') || args.includes('-v');
if (helpFlag) {
    console.log(`
${colors_1.default.cyan.bold('Bible Line')} - Get a random Bible verse

${colors_1.default.yellow('Usage:')}
  bible-line [options]

${colors_1.default.yellow('Options:')}
  -h, --help     Show this help message
  -v, --version  Show version information

${colors_1.default.yellow('Examples:')}
  bible-line
  bible-line --help
  bible-line --version

${colors_1.default.gray('This tool fetches a random chapter from the Bible and displays it with formatted verses.')}
  `);
    process.exit(0);
}
if (versionFlag) {
    console.log(colors_1.default.cyan.bold('Bible Line v1.0.0'));
    process.exit(0);
}
// Main function to get random Bible chapter
function getRandomBibleChapter() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            // Getting Books
            const bibleBooks = Object.keys(bibleData);
            if (bibleBooks.length === 0) {
                throw new Error('No Bible books found in data');
            }
            // Getting Random Number For Book
            const randNumForBooks = Math.floor(Math.random() * bibleBooks.length);
            // Actually Getting The Name of The Book
            const book = bibleBooks[randNumForBooks];
            // Getting Chapter
            const chapter = Math.floor(Math.random() * bibleData[book]) + 1;
            console.log(colors_1.default.blue('Fetching Bible chapter...'));
            const response = yield fetch(`https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles/${version}/books/${book.toString().toLowerCase()}/chapters/${chapter}.json`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const result = yield response.json();
            if (!result.data || !Array.isArray(result.data)) {
                throw new Error('Invalid API response format');
            }
            // Deduplicate verses
            const versesSeen = new Set();
            const versesDeduped = result.data.filter(el => {
                const dupe = versesSeen.has(el.verse);
                versesSeen.add(el.verse);
                return !dupe;
            });
            // Display results
            console.log(colors_1.default.cyan.bold.underline(`\nBook: ${String(book)} - Chapter: ${chapter}\n`));
            let verses = '';
            versesDeduped.forEach(({ verse, text }) => {
                verses += colors_1.default.red(`${verse}  `) + colors_1.default.green(`${text}\n`);
            });
            console.log(verses);
            console.log(colors_1.default.gray(`\nTotal verses: ${versesDeduped.length}`));
        }
        catch (error) {
            console.error(colors_1.default.red.bold('Error:'), colors_1.default.red(error instanceof Error ? error.message : 'An unknown error occurred'));
            console.log(colors_1.default.yellow('\nTips:'));
            console.log(colors_1.default.gray('- Check your internet connection'));
            console.log(colors_1.default.gray('- Try running the command again'));
            console.log(colors_1.default.gray('- Use --help for more information'));
            process.exit(1);
        }
    });
}
// Handle process signals for graceful shutdown
process.on('SIGINT', () => {
    console.log(colors_1.default.yellow('\n\nOperation cancelled by user'));
    process.exit(0);
});
process.on('SIGTERM', () => {
    console.log(colors_1.default.yellow('\n\nOperation terminated'));
    process.exit(0);
});
// Run the main function
getRandomBibleChapter().catch((error) => {
    console.error(colors_1.default.red.bold('Unhandled error:'), colors_1.default.red(error instanceof Error ? error.message : 'An unknown error occurred'));
    process.exit(1);
});
