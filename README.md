# サッカーノートアプリ

## 概要
- スマートフォンなので利用可能なサッカーノートアプリを作成
- 画面遷移，状態管理を実装
- カレンダー内に試合を設定でき，その日のポジションや良い点，反省点などを記入でき，見直すことが可能
- フォーメーションを管理するアプリは既に存在しているが，カレンダーとフォーメーション，サッカーのコメントを紐づけているのが新規性

## 開発環境
- VSCode(編集用)
- Andoroid Studio(動作検証用)
- dart

## 使用したパッケージ
pubspec.yamlを参照

## 新たに追加したい機能
- ローカルでデータを保存できるようにshared_preferenceを用いる
- テストを行う
- fireBaseと接続して，認証をしてアプリをリリース

## 学んだこと
- useStateが使える
- freezedはデータをまとめて管理するのに役立つ，データを変更するときにCopyWithを用いることで型ごと変更できる
- annotationとはコードにメタデータを追加する構文
- 試合によって別のフォーメーションを出す場合は，対戦相手と日にちの状態を動的にインスタンスから渡すことでできる

## 参考文献
- Flutter入門講座，ルビーDog(https://www.youtube.com/watch?v=GN6HXSrObzg&list=PLY1cxwSQf6nz6zo2Y_UJlDjGOpASAO4hd)
- Zenn，Flutter】入力フォームの実装方法を複数試してみる(https://zenn.dev/koichi_51/articles/7f54e079141acc)
- Qiita，Flutter】table_calendarを日本語で表示する(https://qiita.com/mqkotoo/items/4e5324c8f13beb8e264c)
