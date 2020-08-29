Автоматическая установка для выборочного обхода блокировок на маршрутизаторах с прошивкой Keenetic OS.

Подробности читайте в статье "Выборочный обход блокировок на маршрутизаторах с прошивкой Padavan и Keenetic OS" — https://habr.com/ru/post/428992/. Обязательно прочитайте (хотя бы один раз) статью перед тем, как использовать метод автоматической установки, и сделайте необходимые настройки на маршрутизаторе.

ВНИМАНИЯ! Скрипт не проверялся на реальном устройстве (пока не было времени). Только для экспериментаторов. Все остальные должны использовать ручной метод установки, описанный в статье.

Загрузите скрипт установки:
```bash
opkg install wget ca-certificates
wget --no-check-certificate -O /opt/bin/configure_keenetic.sh https://raw.githubusercontent.com/elky92/configure_keenetic/master/configure_keenetic.sh
chmod +x /opt/bin/configure_keenetic.sh
```

Установка (автоматическое выполнение шагов 1-12):
```bash
configure_keenetic.sh
```

После автоматической перезагрузки маршрутизатора для реализации «Дополнительный обход фильтрации DNS-запросов провайдером» (если вам это нужно) выполните команду:
```bash
configure_keenetic.sh dnscrypt
```

Удаление обхода блокировок:
```bash
configure_keenetic.sh remove
```
