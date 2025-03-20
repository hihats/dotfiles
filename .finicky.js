// https://github.com/johnste/finicky/wiki/Configuration-ideas
module.exports = {
  defaultBrowser: "Brave Browser",
  handlers: [
    {
      match: [
        /^https?:\/\/.*\.google\.com\/.*$/,
        /^https?:\/\/forms\.gle\/.*$/,
        /^https?:\/\/www\.figma\.com\/.*$/,
        /^https?:\/\/a-rakumo\.appspot\.com\/.*$/,
        /^https?:\/\/redmine\.crowdworks\.jp\/.*$/,
        /^https?:\/\/redash.*\.crowdworks\.co\.jp\/.*$/,
        /^https?:\/\/.*\.zoom\.us\/.*$/,
        /^https?:\/\/crowdworks\.v1\.herp\.cloud\/.*$/,
      ],
      browser: {
        name: "Google Chrome",
        profile: "Profile 1"
      }
    },
    {
      match: [
        /^https?:\/\/github\.com\/.*$/,
        /^https?:\/\/codeclimate\.com\/.*$/,
        /^https?:\/\/circleci\.com\/.*$/,
        /^https?:\/\/app\.circleci\.com\/.*$/,
        /^https?:\/\/qiita\.com\/.*$/,
        /^https?:\/\/.*\.qiita\.com\/.*$/,
        /^https?:\/\/.*\.connpass\.com\/.*$/,
        /^https?:\/\/app\.datadoghq\.com\/.*$/,
        /^https?:\/\/app\.rollbar\.com\/.*$/,
        /^https?:\/\/dev\.classmethod\.jp\/.*$/,
        /^https?:\/\/findy-team\.io\/.*$/,
        /^https?:\/\/developer.*$/,
      ],
      browser: {
        name: "Sidekick",
        profile: "Default"
      }
    },
    {
      match: /notion.so/,
      browser: 'Notion',
    },
    {
      match: /miro.com/,
      browser: 'Miro',
    },
    {
      match: /crowdworks.slack.com/,
      browser: 'Slack',
    },
    {
      match: "https://www.figma.com/file/*",
      browser: "Figma",
    }
  ],
  rewrite: [{
    match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
    url: ({url}) => {
        const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
        const removeKeys = ["fbclid", "gclid"]; // Remove all query parameters matching these keys

        const search = url.search
            .split("&")
            .map((parameter) => parameter.split("="))
            .filter(([key]) => !removeKeysStartingWith.some((startingWith) => key.startsWith(startingWith)))
            .filter(([key]) => !removeKeys.some((removeKey) => key === removeKey));

        return {
            ...url,
            search: search.map((parameter) => parameter.join("=")).join("&"),
        };
    },
  }]
}
