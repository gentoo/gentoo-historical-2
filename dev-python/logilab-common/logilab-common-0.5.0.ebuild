# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/logilab-common/logilab-common-0.5.0.ebuild,v 1.1.1.1 2005/11/30 10:10:22 chriswhite Exp $

inherit distutils

DESCRIPTION="Several modules providing low level functionality shared among some python projects developed by logilab."
HOMEPAGE="http://www.logilab.org/projects/common/"
SRC_URI="ftp://ftp.logilab.org/pub/common/${P#logilab-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc s390 x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${P#logilab-}

PYTHON_MODNAME="logilab"
DOCS=""
