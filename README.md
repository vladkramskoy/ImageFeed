## **ImageFeed**

ImageFeed - многостраничное приложение предназначеное для просмотра изображений через API Unsplash.

- [Описание приложения](#описание-приложения)
- [Технологии](#технологии)
- [Скриншоты](#скриншоты)

## **Описание приложения**
В приложении реализована авторизация через OAuth Unsplash.
Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
У приложения присутствует механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.


## **Технологии**
- Архитектура MVP
- Верстка в storyboard
- Хранение данных Keychain
- Многопоточность и блокировка UI
- Основы Core Animation
- В приложении использованы: UImageView, UIButton, UILabel, WKWebView, UIProgressView, TabBarController, NavigationController, NavigationBar, UITableView, UITableViewCell
- Интеграция зависимостей через SPM: Kingfisher, ProgressHUD, SwiftKeychainWrapper
- Unit-тесты
- UI-тесты


## **Скриншоты**
<img width="200" src="https://github.com/user-attachments/assets/a13bb1de-3832-4143-9006-c3f0a3daa9cb" />
<img width="200" src="https://github.com/user-attachments/assets/7d5e237e-008a-4ebb-9228-0cdff17d1477" />
<img width="200" src="https://github.com/user-attachments/assets/70d7197c-9573-4009-8605-123edf761e6e" />
<img width="200" src="https://github.com/user-attachments/assets/ecd54f8b-267c-40b3-ab32-723fae9fb750" />

