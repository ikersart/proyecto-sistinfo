#!/bin/bash

sudo systemctl daemon-reload
sudo systemctl enable proyecto_sistinfo_monitorizacion.service
sudo systemctl restart proyecto_sistinfo_monitorizacion.service
