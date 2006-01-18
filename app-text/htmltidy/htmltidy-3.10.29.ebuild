# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/htmltidy/htmltidy-3.10.29.ebuild,v 1.19 2006/01/18 12:18:43 vapier Exp $

inherit eutils

# Convert gentoo version number x.y.z to date xyz for
# tidy's source numbering by date
parts=(${PV//./ })
dates=$(printf "%02d%02d%02d" ${parts[0]} ${parts[1]} ${parts[2]})
MY_P=tidy_src_${dates}
S=${WORKDIR}/tidy

DESCRIPTION="Tidy the layout and correct errors in HTML and XML documents"
HOMEPAGE="http://tidy.sourceforge.net/"
SRC_URI="http://tidy.sourceforge.net/src/old/${MY_P}.tgz
		 http://tidy.sourceforge.net/docs/tidy_docs_040317.tgz
		 xml? ( http://www.cise.ufl.edu/~ppadala/tidy/html2db.tar.gz )"

DEPEND="virtual/libc
	>=sys-devel/autoconf-2.5
	>=sys-devel/automake-1.5"
RDEPEND="virtual/libc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc-macos s390 sh sparc x86"
IUSE="debug doc xml"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Required to setup the source dist for autotools
	einfo "Setting up autotools for source build"
	export WANT_AUTOMAKE=1.5 WANT_AUTOCONF=2.5
	/bin/sh ./build/gnuauto/setup.sh > /dev/null

	# Stop tidy from appending -O2 to our CFLAGS
	sed -e "/save_cflags/s/\ \-O2//" configure.in > ${T}/configure.in &&
	mv ${T}/configure.in configure.in || die "sed configure.in failed"

	if use xml ; then
		# Apply the docbook patch to tidy sources
		epatch ${FILESDIR}/03-${PN}-docbook.patch

		# And the null -> NULL patch to html2db sources
		cd ${WORKDIR}
		epatch ${FILESDIR}/03-html2db-null.patch

		# Point to the tidy source in the html2db Makefile
		sed -e "/TIDYDIR\=/s:\.\.:${S}:" \
			   -e "/LIBDIR\=/s:lib:src\/\.libs\/:" \
			   ${WORKDIR}/html2db/Makefile > ${T}/Makefile &&
		mv ${T}/Makefile ${WORKDIR}/html2db/Makefile || die "sed Makefile failed"
	fi
}

src_compile() {
	export WANT_AUTOMAKE=1.5 WANT_AUTOCONF=2.5
	econf `use_enable debug` || die
	emake || die

	if use xml ; then
		cd ${WORKDIR}/html2db
		emake || die
	fi
}

src_install() {
	make DESTDIR=${D} install || die
	use xml && dobin ${WORKDIR}/html2db/html2db

	cd ${S}/htmldoc
	# It seems the manual page installation in the Makefile's
	# is commented out, so we need to install manually 
	# for the moment. Please check this on updates.
	mv man_page.txt tidy.1
	doman tidy.1

	# Install basic html documentation
	dohtml *.html *.gif *.css
	# If use 'doc' is set, then we also want to install the
	# api documentation
	use doc && dohtml -r api
}
