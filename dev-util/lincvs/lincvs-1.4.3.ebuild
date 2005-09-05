# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/lincvs/lincvs-1.4.3.ebuild,v 1.2 2005/09/05 11:17:44 ferdy Exp $

inherit kde-functions

MY_P="${P/_/-}-0-generic-src"
S="${WORKDIR}/${P/_/-}"

DESCRIPTION="A graphical CVS client."
HOMEPAGE="http://www.lincvs.com"
SRC_URI="http://www.lincvs.com/download/${MY_P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="kde"

DEPEND="kde? ( >=kde-base/kdelibs-3 )"
RDEPEND="${DEPEND}
	dev-util/cvs"
need-qt 3

src_compile() {
	${QTDIR}/bin/qmake -o Makefile lincvs.pro
	sed -i -e "s/^\tstrip/#\tstrip/" \
		-e "s/CFLAGS   = -pipe -Wall -W -O2/CFLAGS   = ${CFLAGS} -Wall -W/" \
		-e "s/CXXFLAGS = -pipe -Wall -W -O2/CXXFLAGS = ${CXXFLAGS} -Wall -W/" Makefile \
	|| die "sed failed"
	emake || die "make failed"
}

src_install() {
	emake install || die "make install failed"
	echo "#!/bin/sh" > ${S}/LinCVS/lincvs
	echo "exec /usr/share/LinCVS/AppRun" >> ${S}/LinCVS/lincvs
	dobin LinCVS/lincvs
	rm ${S}/LinCVS/lincvs
	dodir /usr/share
	cp -pr ${S}/LinCVS ${D}/usr/share
	fperms 644 /usr/share/LinCVS/AppI* /usr/share/LinCVS/Messages/* \
		/usr/share/LinCVS/Help/* /usr/share/LinCVS/Help/Translations/*/*
	fperms 755 /usr/share/LinCVS/AppRun /usr/share/LinCVS/Tools/*
	dodoc AUTHORS BUGS.txt ChangeLog COPYING LICENSE NEWS THANKS VERSION
}
