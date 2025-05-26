sudo systemctl daemon-reload
sudo systemctl restart sync-watch.service
sudo journalctl -f -u sync-watch.service


echo "Sync service location: /etc/systemd/system/sync-watch.service"