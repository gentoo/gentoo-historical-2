# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmltidy/htmltidy-2.7.18-r2.ebuild,v 1.2 2004/04/08 22:53:10 vapier Exp $

inherit eutils

# convert from normalized gentoo version number to htmltidy's wacky date thing
parts=(${PV//./ })
vers=$(printf "%02d%02d%02d" ${parts[0]} ${parts[1]} ${parts[2]})
MY_P=tidy_src_${vers}
S=${WORKDIR}/tidy

DESCRIPTION="Tidy the layout and correct errors in HTML and XML documents"
HOMEPAGE="http://tidy.sourceforge.net/"
SRC_URI="http://tidy.sourceforge.net/src/old/${MY_P}.tgz
		 http://tidy.sourceforge.net/docs/tidy_docs.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="xml doc"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	use xml && epatch ${FILESDIR}/htmltidy-dbpatch.diff

	# Prevent tidy from chown/grp'ing itself to 'tidy:tidy'
	sed -i -e "s:chgrp\|chown:#&:" Makefile
}

src_compile() {
	emake OTHERCFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	# Need to move the man page around, thanks to the flaky Makefile
	cp ${S}/htmldoc/man_page.txt  ${S}/man_page.txt

	make \
		INSTALLDIR="${D}/usr/" MANPAGESDIR="${D}/usr/share/man/" \
		install || die

	# This installs the standard project documentation
	cd ${S}/htmldoc
	dohtml *.html *.gif *.css
	# and the api documentation if we have USE="doc"
	use doc && dohtml -r api
}
