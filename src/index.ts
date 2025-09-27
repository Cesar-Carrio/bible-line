#!/usr/bin/env node

import * as fs from 'fs';
import * as path from 'path';
import colors from 'colors';
import * as blessed from 'blessed';

// Import bible data with proper typing
const bibleDataPath = path.join(__dirname, 'data', 'bibleChapters.json');
const bibleData = JSON.parse(fs.readFileSync(bibleDataPath, 'utf8'));

type BibleBooks = keyof typeof bibleData;
type BibleResponse = {
  book: BibleBooks;
  chapter: number;
  verse: number;
  text: string;
};

interface BibleApiResponse {
  data: BibleResponse[];
}

const version = 'en-kjv';

// Function to display content in a scrollable terminal interface
function displayScrollableContent(title: string, content: string): void {
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
  screen.key(['escape', 'q', 'C-c'], function() {
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
${colors.cyan.bold('Bible Line')} - Get a random Bible verse

${colors.yellow('Usage:')}
  bible-line [options]

${colors.yellow('Options:')}
  -h, --help     Show this help message
  -v, --version  Show version information
  -c, --console  Use traditional console output (default is scrollable view)

${colors.yellow('Examples:')}
  bible-line                    # Uses scrollable view (default)
  bible-line --console          # Uses traditional console output
  bible-line --help
  bible-line --version

${colors.gray('This tool fetches a random chapter from the Bible and displays it with formatted verses.')}
  `);
  process.exit(0);
}

if (versionFlag) {
  console.log(colors.cyan.bold('Bible Line v1.0.0'));
  process.exit(0);
}

// Main function to get random Bible chapter
async function getRandomBibleChapter(): Promise<void> {
  try {
    // Getting Books
    const bibleBooks: BibleBooks[] = Object.keys(bibleData) as BibleBooks[];
    
    if (bibleBooks.length === 0) {
      throw new Error('No Bible books found in data');
    }
    
    // Getting Random Number For Book
    const randNumForBooks: number = Math.floor(Math.random() * bibleBooks.length);
    // Actually Getting The Name of The Book
    const book: BibleBooks = bibleBooks[randNumForBooks];
    // Getting Chapter
    const chapter: number = Math.floor(Math.random() * bibleData[book]) + 1;

    console.log(colors.blue('Fetching Bible chapter...'));

    const response = await fetch(
      `https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles/${version}/books/${book.toString().toLowerCase()}/chapters/${chapter}.json`
    );

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const result: BibleApiResponse = await response.json();

    if (!result.data || !Array.isArray(result.data)) {
      throw new Error('Invalid API response format');
    }

    // Deduplicate verses
    const versesSeen = new Set<number>();
    const versesDeduped = result.data.filter(el => {
      const dupe = versesSeen.has(el.verse);
      versesSeen.add(el.verse);
      return !dupe;
    });

    // Display results
    const title = `Book: ${String(book)} - Chapter: ${chapter}`;
    
    let verses = '';
    versesDeduped.forEach(({ verse, text }: BibleResponse) => {
      verses += `${verse}  ${text}\n`;
    });

    if (consoleFlag) {
      // Use traditional console output
      console.log(colors.cyan.bold.underline(`\n${title}\n`));
      
      let coloredVerses = '';
      versesDeduped.forEach(({ verse, text }: BibleResponse) => {
        coloredVerses += colors.red(`${verse}  `) + colors.green(`${text}\n`);
      });

      console.log(coloredVerses);
      console.log(colors.gray(`\nTotal verses: ${versesDeduped.length}`));
    } else {
      // Use scrollable interface (default)
      displayScrollableContent(title, verses + `\nTotal verses: ${versesDeduped.length}`);
    }

  } catch (error) {
    console.error(colors.red.bold('Error:'), colors.red(error instanceof Error ? error.message : 'An unknown error occurred'));
    console.log(colors.yellow('\nTips:'));
    console.log(colors.gray('- Check your internet connection'));
    console.log(colors.gray('- Try running the command again'));
    console.log(colors.gray('- Use --help for more information'));
    process.exit(1);
  }
}

// Handle process signals for graceful shutdown
process.on('SIGINT', () => {
  console.log(colors.yellow('\n\nOperation cancelled by user'));
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log(colors.yellow('\n\nOperation terminated'));
  process.exit(0);
});

// Run the main function
getRandomBibleChapter().catch((error) => {
  console.error(colors.red.bold('Unhandled error:'), colors.red(error instanceof Error ? error.message : 'An unknown error occurred'));
  process.exit(1);
});
