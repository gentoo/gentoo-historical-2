# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktalkd/ktalkd-3.4.1.ebuild,v 1.3 2005/06/30 21:02:26 danarmak Exp $

KMNAME=kdenetwork
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE talk daemon"
KEYWORDS="x86 amd64 ~ppc64 ~ppc ~sparc"
IUSE=""
KMEXTRA="doc/kcontrol/kcmktalkd"