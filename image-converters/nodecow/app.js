const fs = require('fs');
const path = require('path');
const { createCanvas, loadImage } = require('canvas');


const file = process.argv[2];
const outputFileName = `${path.parse(file).name}.cow`;


    function rgbToHex(rgb) {
        return '#' + leadingZero(rgb.r.toString(16)) +
          leadingZero(rgb.g.toString(16)) + leadingZero(rgb.b.toString(16));
      }

    function nearestColor(needle, colors) {
      needle = parseColor(needle);
  
      if (!needle) {
        return null;
      }
  
      var distanceSq,
          minDistanceSq = Infinity,
          rgb,
          value;
  
      colors || (colors = nearestColor.BASH_COLORS);
  
      for (var i = 0; i < colors.length; ++i) {
        rgb = colors[i].rgb;
  
        distanceSq = (
          Math.pow(needle.r - rgb.r, 2) +
          Math.pow(needle.g - rgb.g, 2) +
          Math.pow(needle.b - rgb.b, 2)
        );
  
        if (distanceSq < minDistanceSq) {
          minDistanceSq = distanceSq;
          value = colors[i];
        }
      }
  
      if (value.name) {
        return {
          name: value.name,
          value: value.source,
          rgb: value.rgb,
          distance: Math.sqrt(minDistanceSq)
        };
      }
  
      return value.source;
    }
    nearestColor.from = function from(availableColors) {
      var colors = mapColors(availableColors),
          nearestColorBase = nearestColor;
  
      var matcher = function nearestColor(hex) {
        return nearestColorBase(hex, colors);
      };
      matcher.from = from;
  
      // Also provide a way to combine multiple color lists.
      matcher.or = function or(alternateColors) {
        var extendedColors = colors.concat(mapColors(alternateColors));
        return nearestColor.from(extendedColors);
      };
  
      return matcher;
    };
  
    function mapColors(colors) {
      if (colors instanceof Array) {
        return colors.map(function(color) {
          return createColorSpec(color);
        });
      }
  
      return Object.keys(colors).map(function(name) {
        return createColorSpec(colors[name], name);
      });
    };

    function parseColor(source) {
      var red, green, blue;
  
      if (typeof source === 'object') {
        return source;
      }
  
      if (source in nearestColor.STANDARD_COLORS) {
        return parseColor(nearestColor.STANDARD_COLORS[source]);
      }
  
      var hexMatch = source.match(/^#?((?:[0-9a-f]{3}){1,2})$/i);
      if (hexMatch) {
        hexMatch = hexMatch[1];
  
        if (hexMatch.length === 3) {
          hexMatch = [
            hexMatch.charAt(0) + hexMatch.charAt(0),
            hexMatch.charAt(1) + hexMatch.charAt(1),
            hexMatch.charAt(2) + hexMatch.charAt(2)
          ];
  
        } else {
          hexMatch = [
            hexMatch.substring(0, 2),
            hexMatch.substring(2, 4),
            hexMatch.substring(4, 6)
          ];
        }
  
        red = parseInt(hexMatch[0], 16);
        green = parseInt(hexMatch[1], 16);
        blue = parseInt(hexMatch[2], 16);
  
        return { r: red, g: green, b: blue };
      }
  
      var rgbMatch = source.match(/^rgb\(\s*(\d{1,3}%?),\s*(\d{1,3}%?),\s*(\d{1,3}%?)\s*\)$/i);
      if (rgbMatch) {
        red = parseComponentValue(rgbMatch[1]);
        green = parseComponentValue(rgbMatch[2]);
        blue = parseComponentValue(rgbMatch[3]);
  
        return { r: red, g: green, b: blue };
      }
  
      throw Error('"' + source + '" is not a valid color');
    }
  
    function createColorSpec(input, name) {
      var color = {};
  
      if (name) {
        color.name = name;
      }
  
      if (typeof input === 'string') {
        color.source = input;
        color.rgb = parseColor(input);
  
      } else if (typeof input === 'object') {
        if (input.source) {
          return createColorSpec(input.source, input.name);
        }
  
        color.rgb = input;
        color.source = rgbToHex(input);
      }
  
      return color;
    }

    function parseComponentValue(string) {
      if (string.charAt(string.length - 1) === '%') {
        return Math.round(parseInt(string, 10) * 255 / 100);
      }
  
      return Number(string);
    }
  
    function leadingZero(value) {
      if (value.length === 1) {
        value = '0' + value;
      }
      return value;
    }
  
    nearestColor.STANDARD_COLORS = {
      aqua: '#0ff',
      black: '#000',
      blue: '#00f',
      fuchsia: '#f0f',
      gray: '#808080',
      green: '#008000',
      lime: '#0f0',
      maroon: '#800000',
      navy: '#000080',
      olive: '#808000',
      orange: '#ffa500',
      purple: '#800080',
      red: '#f01',
      silver: '#c0c0c0',
      teal: '#008080',
      white: '#fff',
      yellow: '#ff0'
    };
  
    nearestColor.BASH_COLORS = mapColors([
       '#000000',    '#000c5f',    '#011587',    '#011faf',    '#0328d7',    '#0433ff',    '#005f01',    '#005f60',
       '#005f87',    '#005fb0',    '#005fd7',    '#005fff',    '#008701',    '#01875f',    '#008787',    '#0087af',
       '#0087d7',    '#0087ff',    '#00af01',    '#00af5f',    '#00af87',    '#00afaf',    '#00afd7',    '#00aeff',
       '#00d701',    '#01d760',    '#00d787',    '#00d7af',    '#00d7d7',    '#00d7ff',    '#05f900',    '#04f95f',
       '#02fa87',    '#03fbaf',    '#03fcd7',    '#02fcff',    '#5f0800',    '#5f115f',    '#5f1987',    '#5e23af',
       '#5f2bd8',    '#5f34ff',    '#5f5f00',    '#5f5f5f',    '#5f5f87',    '#5f5faf',    '#5f5fd7',    '#5f5fff',
       '#5f8700',    '#5f875f',    '#5f8787',    '#5f87af',    '#5f87d7',    '#5f87ff',    '#5faf00',    '#5faf5f',
       '#5faf87',    '#5fafaf',    '#5eafd7',    '#5fafff',    '#5fd700',    '#5fd75f',    '#5fd787',    '#5fd7af',
       '#5fd7d7',    '#5fd7ff',    '#60f900',    '#60fa5f',    '#60fa87',    '#5ffbaf',    '#5ffcd7',    '#5ffdff',
       '#870f00',    '#86165f',    '#871e87',    '#8725b0',    '#872ed7',    '#8736ff',    '#875f01',    '#875f5f',
       '#875f87',    '#875faf',    '#875fd7',    '#875fff',    '#878701',    '#87875f',    '#878787',    '#8787af',
       '#8787d7',    '#8787ff',    '#87af00',    '#87af5f',    '#87af87',    '#87afaf',    '#87afd7',    '#87afff',
       '#87d700',    '#87d760',    '#87d787',    '#87d7af',    '#87d7d7',    '#87d7ff',    '#87f901',    '#87fa5f',
       '#87fb87',    '#87fbaf',    '#87fcd8',    '#87fdff',    '#af1601',    '#af1c5f',    '#af2287',    '#af29af',
       '#af31d7',    '#af39ff',    '#af5f00',    '#b05e5f',    '#af5f87',    '#af5faf',    '#af5fd7',    '#af5fff',
       '#af8700',    '#af875f',    '#af8787',    '#af87af',    '#af87d7',    '#af87ff',    '#afaf00',    '#afaf5f',
       '#afaf87',    '#afafaf',    '#afafd7',    '#afafff',    '#afd701',    '#afd75f',    '#afd787',    '#afd7af',
       '#afd7d7',    '#afd7ff',    '#affa01',    '#affb5f',    '#affb88',    '#affbaf',    '#b0fdd7',    '#affeff',
       '#d71e00',    '#d7235f',    '#d72787',    '#d72eaf',    '#d734d7',    '#d73cff',    '#d75f01',    '#d75f5e',
       '#d75f87',    '#d75faf',    '#d75fd7',    '#d75fff',    '#d78701',    '#d7875f',    '#d78787',    '#d887af',
       '#d787d7',    '#d787ff',    '#d7af00',    '#d7af5f',    '#d7af87',    '#d7afb0',    '#d7afd7',    '#d7afff',
       '#d7d700',    '#d7d75f',    '#d7d787',    '#d7d7af',    '#d7d7d7',    '#d7d7ff',    '#d7fb00',    '#d7fb5f',
       '#d7fc87',    '#d7fcaf',    '#d7fdd7',    '#d7feff',    '#ff2500',    '#ff2a5f',    '#ff2d87',    '#ff33af',
       '#ff39d7',    '#fe40ff',    '#ff5f00',    '#ff5f5f',    '#ff5f87',    '#ff5faf',    '#ff5fd7',    '#ff5fff',
       '#ff8700',    '#ff875f',    '#ff8787',    '#ff87af',    '#ff87d7',    '#ff87ff',    '#ffaf00',    '#ffaf5f',
       '#ffaf87',    '#ffafaf',    '#ffafd8',    '#ffafff',    '#ffd600',    '#ffd75f',    '#ffd787',    '#ffd7af',
       '#ffd7d8',    '#ffd7ff',    '#fefb01',    '#fffc5e',    '#fffc87',    '#fffdaf',    '#fffed7',    '#ffffff',
       '#080808',    '#121212',    '#1c1c1c',    '#262626',    '#303030',    '#3a3a3a',    '#444444',    '#4e4e4e',
       '#585858',    '#626262',    '#6c6c6c',    '#767676',    '#808080',    '#8a8a8a',    '#949494',    '#9e9e9e',
       '#a8a8a8',    '#b2b2b2',    '#bcbcbc',    '#c6c6c6',    '#d0d0d0',    '#dadada',    '#e4e4e4',    '#eeeeee']);
  
    var bashMap = {};
    nearestColor.BASH_COLORS.forEach(function(color, i) {
      bashMap[color.source] = i + 16; //skip first 16 colors since they differ per terminal config
    });
    nearestColor.BASH_MAP = bashMap;
  
    nearestColor.VERSION = '0.4.4';
  
    if (typeof module === 'object' && module && module.exports) {
      module.exports = nearestColor;
    } else {
      context.nearestColor = nearestColor;
      context.rgbToHex = rgbToHex;
      context.parseColor = parseColor;
    }

  

    function each(arr, func) {
        var i;
        for (i = 0; i < arr.length; i++) {
          func(arr[i]);
        }
      }

      function range(lo, hi) {
        var range = [];
        var i;
        for (i = lo; i < hi; i++) {
          range.push(i);
        }
        return range;
      }

      function bashColor(px) {
        
          var pxColor = rgbToHex({r: px[0], g: px[1], b: px[2]});
          var foundColor = nearestColor.BASH_MAP[nearestColor(pxColor)];
          return foundColor;
        
      }

      var varNames = ['x', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
      'p', 'q', 'r', 's', 'u', 'v', 'w', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
      'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

      // add shitload of extra variable names for full color support
      each('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', l1 => {
        each('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', l2 => {
          varNames.push(l1 + l2);
        });
      });



// const file = process.argv[2];


loadImage(file).then((image) => {
    var showThoughts = true;
    var colorCount = 0;
    var varMap = {};
    // console.log(file.name)

    const canvas = createCanvas();
  canvas.width = image.width;
  canvas.height = image.height;
  var ctx = canvas.getContext('2d');
  ctx.drawImage(image, 0, 0, image.width, image.height);

    //set background color to 1st pixel found
    var cowFileVars = '$' + varNames[0] + ' = "\\e[49m  ";          #reset color\n$t = "$thoughts ";\n';
    var cowFile = '';
    var bgColor = bashColor(ctx.getImageData(0, 0, 1, 1).data);
    varMap[bgColor] = varNames[0];
    colorCount++;
    var lastColor = bgColor;
    var scale = 2;
    var height = image.height;
    var width = image.width / scale;
    height = Math.min(height, (image.height / scale));
    var leftBound =  0;

    each(range(0, height), function(yval) { //rows
        var y = yval * scale;
        var whiteSpace = '';
        each(range(leftBound, width), function(xval) { //columns
          var x = xval * scale;
        //   console.log('pixel (' + x + ', ' + y + ')');
          var px = ctx.getImageData(x, y, 1, 1).data;
          var foundColor = bashColor(px);
          if (foundColor !== lastColor) {
            cowFile += whiteSpace;
            whiteSpace = '';
            lastColor = foundColor;
            var varName = varMap[foundColor];
            if (!varName) {
              varName = varNames[colorCount];
              colorCount++;
              varMap[foundColor] = varName;
              
                cowFileVars += '$' + varName + ' = "\\e[48;5;' + foundColor + 'm  ";\n';
              
            }
            cowFile += '$' + varName;
          } else {
            var diagonalColor = bashColor(ctx.getImageData(x + scale, y + scale, 1, 1).data);
            if (showThoughts && (yval < 5) && (yval === ((xval - leftBound) - 5)) && (foundColor === bgColor) && (diagonalColor === bgColor)) {
              cowFile += whiteSpace + '$t';
              whiteSpace = '';
            } else {
              if (lastColor == bgColor) {
                whiteSpace += '  ';
              } else {
                cowFile += '  ';
              }
            }
          }
        });
        if (lastColor !== bgColor) {
          cowFile += '$' + varNames[0];
          lastColor = bgColor;
        }
        cowFile += '\n';
      });

      var outFile = '# ' + 
                              '\n# Generated with Charc0al\'s cowsay file converter http://charc0al.github.io/cowsay-files/converter\n\n' +
                              cowFileVars + '\n$the_cow = <<EOC\n' + cowFile + 'EOC\n';

console.log(outFile)
const variableToOutputToFile = outFile; // Replace with your variable
fs.writeFile(outputFileName, variableToOutputToFile, (err) => {
    if (err) throw err;
    console.log(`Variable written to ${outputFileName}`);
  });
  
  
}).catch((err) => {
  console.error(err);
});
