# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Arcady Genkin <agenkin@thpoon.com>
# $Header: /var/cvsroot/gentoo-x86/app-editors/xemacs-packages-sumo/xemacs-packages-sumo-2002.01.19.ebuild,v 1.1 2002/02/16 05:09:27 agenkin Exp $

DESCRIPTION="The SUMO bundle of ELISP packages for Xemacs"
HOMEPAGE="http://www.xemacs.org"
SRC_URI="http://ftp.us.xemacs.org/ftp/pub/xemacs/packages/xemacs-sumo-2002-01-19.tar.bz2"

S="${WORKDIR}"
DEPEND=""

src_install () {
	mkdir -p "${D}/usr/lib/xemacs"
	mv "${S}/xemacs-packages" "${D}/usr/lib/xemacs/"
}
