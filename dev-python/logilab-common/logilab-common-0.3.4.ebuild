# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/logilab-common/logilab-common-0.3.4.ebuild,v 1.4 2004/05/04 11:51:24 kloeri Exp $

inherit distutils

DESCRIPTION="Several modules providing low level functionnalities shared among some python projects developped by logilab."
SRC_URI="ftp://ftp.logilab.org/pub/common/${P#logilab-}.tar.gz"
HOMEPAGE="http://www.logilab.org/projects/common/"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"
DEPEND=""
IUSE=""

S=${WORKDIR}/${P#logilab-}

PYTHON_MODNAME="logilab"
DOCS=""
