# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klaptopdaemon/klaptopdaemon-3.4.0_beta1.ebuild,v 1.1 2005/01/15 02:24:33 danarmak Exp $

KMNAME=kdeutils
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="klaptopdaemon - KDE battery monitoring and management for laptops"
KEYWORDS="~x86"
IUSE=""

# From kde cvs, remove after beta1
PATCHES="$FILESDIR/acpi_helper.diff"
