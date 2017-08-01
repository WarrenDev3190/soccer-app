const Elm = require('./elm/Main.elm');

Elm.Main.embed(document.getElementById('app'),
{footBallAPiKey: FOOTBALL_API_KEY,
  footBallApiBaseUrl: FOOTBALL_API_BASE_URL});
