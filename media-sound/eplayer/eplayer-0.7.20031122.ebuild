# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/eplayer/eplayer-0.7.20031122.ebuild,v 1.1 2003/11/22 08:54:13 vapier Exp $

inherit enlightenment

DESCRIPTION="an audio player built on the EFL"

DEPEND="media-libs/libvorbis
	>=media-video/ffmpeg-0.4.8
	>=x11-libs/ecore-1.0.0.20031018_pre4
	>=x11-libs/evas-1.0.0.20031018_pre12
	>=media-libs/edje-0.0.1.20031018
	>=x11-libs/esmart-0.0.2.20031018"
