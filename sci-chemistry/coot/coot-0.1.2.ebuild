# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/coot/coot-0.1.2.ebuild,v 1.5 2009/10/10 00:10:29 patrick Exp $

inherit autotools

MY_PV=${PV/_pre/-pre-}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Crystallographic Object-Oriented Toolkit for model building, completion and validation"
HOMEPAGE="http://www.biop.ox.ac.uk/coot/"
RESTRICT="mirror"
if [[ ${MY_PV} = *pre* ]]; then
	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/pre-release/${MY_P}.tar.gz"
else
	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/${MY_P}.tar.gz"
fi
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""
RDEPEND=">=sci-libs/gsl-1.3
	=dev-libs/glib-1.2*
	=x11-libs/gtkglarea-1.2*
	x11-libs/gtkglext
	virtual/glut
	virtual/opengl
	sci-chemistry/ccp4
	dev-lang/python
	x11-libs/gtk-canvas
	x11-libs/guile-gtk
	dev-scheme/guile-gui
	dev-scheme/net-http
	dev-scheme/goosh
	dev-scheme/guile-www
	sci-libs/coot-data
	sci-chemistry/reduce
	sci-chemistry/probe"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	# Link against single-precision fftw
	sed -i \
		-e "s:lfttw:lsfttw:g" \
		-e "s:lrfttw:lsrfttw:g" \
		"${S}"/macros/clipper.m4

	# Don't install setup scripts, they're only needed for nonstandard prefixes
	sed -i \
		-e "s:^\(setup.*\):#\1:g" \
		-e "s:.*\(bin_.*\):\1:g" \
		"${S}"/setup/Makefile.am

	# Fix where it looks for some binaries
	sed -i \
		-e "s:/y/people/emsley/coot/Linux/bin/probe.2.11.050121.linux.RH9:/usr/bin/probe:g" \
		-e "s:/y/people/emsley/coot/Linux/bin/reduce.2.21.030604:/usr/bin/reduce:g" \
		"${S}"/scheme/group-settings.scm

	cd "${S}"
	AT_M4DIR="macros" eautoreconf
}

src_compile() {
	# All the --with's are used to activate various parts.
	# Yes, this is broken behavior.
	econf \
		--includedir='${prefix}/include/coot' \
		--with-gtkcanvas-prefix=/usr \
		--with-clipper-prefix=/usr \
		--with-mmdb-prefix=/usr \
		--with-ssmlib-prefix=/usr \
		--with-guile=/usr \
		--with-python=/usr \
		|| die "econf failed"

	# Parallel build's broken
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	# Install misses this
	insinto /usr/share/coot/python
	doins "${S}"/src/coot.py
}
