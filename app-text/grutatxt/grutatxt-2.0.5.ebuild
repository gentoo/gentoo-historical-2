# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/grutatxt/grutatxt-2.0.5.ebuild,v 1.2 2004/04/26 11:42:10 obz Exp $

inherit perl-module

MY_PN="Grutatxt"
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A converter from plain text to HTML and other markup languages"
HOMEPAGE="http://triptico.com/software/grutatxt.html"
SRC_URI="http://www.triptico.com/download/${MY_P}.tar.gz"
LICENSE="GPL-2"

IUSE=""
SLOT="0"
KEYWORDS="x86"

# set the script path to /usr/bin, rather than /usr/local/bin
myconf="INSTALLSCRIPT=/usr/bin"

