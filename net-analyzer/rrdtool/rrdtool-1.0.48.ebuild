# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/rrdtool/rrdtool-1.0.48.ebuild,v 1.1 2004/08/05 22:19:16 squinky86 Exp $

inherit perl-module flag-o-matic gnuconfig eutils

DESCRIPTION="A system to store and display time-series data"
HOMEPAGE="http://people.ee.ethz.ch/~oetiker/webtools/rrdtool/"
SRC_URI="http://people.ee.ethz.ch/%7Eoetiker/webtools/${PN}/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64"
IUSE="perl tcltk"

DEPEND="perl? ( dev-lang/perl )
	sys-apps/gawk
	>=media-libs/gd-1.8.3"
RDEPEND="tcltk? ( dev-lang/tcl )"

TCLVER=""

pkg_setup() {
	if use perl ; then
		perl-module_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-fPIC.patch
}

src_compile() {
	filter-mfpmath sse
	filter-flags -ffast-math

	local myconf
	myconf="${myconf} --datadir=/usr/share --enable-shared"

	use tcltk \
		&& myconf="${myconf} --with-tcllib=/usr/lib" \
		|| myconf="${myconf} --without-tcllib"

	if use perl; then
		econf ${myconf} --with-perl-options='PREFIX=/usr INSTALLDIRS=vendor DESTDIR=${D}' || die "econf failed"

		# libraries without -fPIC? feh!
		for libdir in cgilib* gd* libpng* zlib*; do
			sed -i -e 's/^CFLAGS.*/& -fPIC/' ${libdir}/Makefile
		done
	else
		econf ${myconf} || die "econf failed"
	fi

	make || die "make failed"
}

src_install() {
	einstall || die

	# this package completely ignores mandir settings

	doman doc/*.1
	dohtml doc/*.html
	dodoc doc/*.pod
	dodoc doc/*.txt

	rm -rf ${D}/usr/doc
	rm -rf ${D}/usr/html
	rm -rf ${D}/usr/man
	rm -rf ${D}/usr/contrib
	rm -rf ${D}/usr/examples

	insinto /usr/share/doc/${PF}/examples
	doins examples/*
	insinto /usr/share/doc/${PF}/contrib
	doins contrib/*

	if use perl ; then
		perlinfo
		mytargets="site-perl-install"
		perl-module_src_install || die

		# remove duplicate installation into /usr/lib/perl
		rm -Rf ${D}/usr/lib/perl
	fi

	if use tcltk ; then
#		mv ${S}/tcl/tclrrd.so ${S}/tcl/tclrrd${PV}.so
#		insinto /usr/lib/tcl${TCL_VER}/tclrrd${PV}
#		doins ${S}/tcl/tclrrd${PV}.so
		echo "package ifneeded Rrd ${PV} [list load [file join \$$dir .. tclrrd${PV}.so]]" \
			>> ${D}/usr/lib/tcl${TCL_VER}/tclrrd${PV}/pkgIndex.tcl
	fi

	dodoc COPY* CONTR* README TODO
}

pkg_preinst() {
	use perl && perl-module_pkg_preinst
}

pkg_postinst() {
	use perl && perl-module_pkg_postinst
}

pkg_prerm() {
	use perl && perl-module_pkg_prerm
}

pkg_postrm() {
	use perl && perl-module_pkg_postrm
}
