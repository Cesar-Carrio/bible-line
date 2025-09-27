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
const blessed = __importStar(require("blessed"));
// Import bible data with proper typing
const bibleDataPath = path.join(__dirname, 'data', 'bibleChapters.json');
const bibleData = JSON.parse(fs.readFileSync(bibleDataPath, 'utf8'));
const version = 'en-kjv';
// Function to display content in a scrollable terminal interface
function displayScrollableContent(title, content) {
    // Create a screen object
    const screen = blessed.screen({
        smartCSR: true,
        title: 'Bible Line - Scrollable View'
    });
    // Create a scrollable box
    const box = blessed.box({
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        content: `${title}\n\n${content}`,
        tags: true,
        border: {
            type: 'line'
        },
        style: {
            fg: 'white',
            bg: 'black',
            border: {
                fg: 'cyan'
            }
        },
        scrollable: true,
        alwaysScroll: true,
        scrollbar: {
            ch: ' ',
            track: {
                bg: 'cyan'
            },
            style: {
                inverse: true
            }
        },
        keys: true,
        vi: true,
        mouse: true
    });
    // Add instructions at the bottom
    const instructions = blessed.box({
        bottom: 0,
        left: 0,
        width: '100%',
        height: 3,
        content: '{center}{cyan-fg}Use ↑↓ arrows or j/k to scroll • Press q or Ctrl+C to exit{/cyan-fg}{/center}',
        tags: true,
        style: {
            fg: 'white',
            bg: 'black'
        }
    });
    // Append to screen
    screen.append(box);
    screen.append(instructions);
    // Key bindings
    screen.key(['escape', 'q', 'C-c'], function () {
        return process.exit(0);
    });
    // Focus the scrollable box
    box.focus();
    // Render the screen
    screen.render();
}
// Command line argument handling
const args = process.argv.slice(2);
const helpFlag = args.includes('--help') || args.includes('-h');
const versionFlag = args.includes('--version') || args.includes('-v');
const consoleFlag = args.includes('--console') || args.includes('-c');
if (helpFlag) {
    console.log(`
${colors_1.default.cyan.bold('Bible Line')} - Get a random Bible verse

${colors_1.default.yellow('Usage:')}
  bible-line [options]

${colors_1.default.yellow('Options:')}
  -h, --help     Show this help message
  -v, --version  Show version information
  -c, --console  Use traditional console output (default is scrollable view)

${colors_1.default.yellow('Examples:')}
  bible-line                    # Uses scrollable view (default)
  bible-line --console          # Uses traditional console output
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
            const title = `Book: ${String(book)} - Chapter: ${chapter}`;
            let verses = '';
            versesDeduped.forEach(({ verse, text }) => {
                verses += `${verse}  ${text}\n`;
            });
            if (consoleFlag) {
                // Use traditional console output
                console.log(colors_1.default.cyan.bold.underline(`\n${title}\n`));
                let coloredVerses = '';
                versesDeduped.forEach(({ verse, text }) => {
                    coloredVerses += colors_1.default.red(`${verse}  `) + colors_1.default.green(`${text}\n`);
                });
                console.log(coloredVerses);
                console.log(colors_1.default.gray(`\nTotal verses: ${versesDeduped.length}`));
            }
            else {
                // Use scrollable interface (default)
                displayScrollableContent(title, verses + `\nTotal verses: ${versesDeduped.length}`);
            }
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
