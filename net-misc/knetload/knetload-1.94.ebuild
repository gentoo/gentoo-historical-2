# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/knetload/knetload-1.94.ebuild,v 1.5 2002/07/11 06:30:48 drobbins Exp $

inherit kde-base || die

need-kde 3

KEYWORDS="x86"
LICENSE="GPL-2"
DESCRIPTION="A Network applet for KDE2"
SRC_URI="http://ftp.kde.com/Computer_Devices/Networking/Monitoring/KNETLoad/${PN}-1.9.4.tar.gz
	http://kde.quakenet.eu.org/files/${PN}-1.9.4.tar.gz"
HOMEPAGE="http://kde.quakenet.eu.org/knetload.shtml"
S=${WORKDIR}/${PN}-1.9.4

