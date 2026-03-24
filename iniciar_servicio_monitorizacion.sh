#!/bin/bash

sudo chmod +x ./monitorizacion.sh

sudo systemctl daemon-reload
sudo systemctl enable proyecto_sistinfo_monitorizacion.service
sudo systemctl restart proyecto_sistinfo_monitorizacion.service
