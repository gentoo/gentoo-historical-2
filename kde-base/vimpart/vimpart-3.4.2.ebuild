# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/vimpart/vimpart-3.4.2.ebuild,v 1.3 2005/10/13 00:10:09 danarmak Exp $
KMNAME=kdeaddons
MAXKDEVER=3.4.3
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE embeddable VIM editor part"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND=""

# use /usr/bin/kvim not /usr/bin/vim
# fixes 33257
# is gentoo-specific and wont go upstream, so continue to apply to future versions
PATCHES=$FILESDIR/kdeaddons-3.2.0-kvim.diff