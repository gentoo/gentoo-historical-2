# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/keditfiletype/keditfiletype-4.3.0.ebuild,v 1.1 2009/08/04 00:29:01 wired Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE mime/file type assocciation editor"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# test fails, last checked for 4.2.89
RESTRICT=test

# @Since 4.2.68 - split from konqueror
RDEPEND="
	!kdeprefix? ( !<=kde-base/konqueror-4.2.67:4.2[-kdeprefix] )
	kdeprefix? ( !<=kde-base/konqueror-4.2.67:4.3 )
"
