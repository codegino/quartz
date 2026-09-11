When an error like this occure
```sh
> pnpm run build:android:dev

> money-manager-app@0.0.1 build:android:dev /Users/catapang001/git/oss/MoneyManagerApp

> eas build --profile development:device --platform android --local

sh: eas: command not found
```

do
```sh
npm install -g eas-cli
```



