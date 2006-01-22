# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons-kfile-plugins/kdeaddons-kfile-plugins-3.5.0.ebuild,v 1.6 2006/01/22 22:52:54 danarmak Exp $
KMNAME=kdeaddons
KMNOMODULE=true
KMEXTRA="kfile-plugins/"
MAXKDEVER=3.5.1
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kdeaddons kfile plugins"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="ssl? ( dev-libs/openssl )"

# kfile-cert requires ssl

