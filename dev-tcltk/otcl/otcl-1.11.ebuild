# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/otcl/otcl-1.11.ebuild,v 1.3 2006/07/27 04:01:41 tsunam Exp $

inherit eutils autotools virtualx

DESCRIPTION="MIT Object extension to Tcl"
HOMEPAGE="http://otcl-tclcl.sourceforge.net/otcl/"
SRC_URI="mirror://sourceforge/otcl-tclcl/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-lang/tcl-8.4.5
		>=dev-lang/tk-8.4.5"

# the package is not safe :-(
MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}

	EPATCH_OPTS="-p1 -d${S}" epatch ${FILESDIR}/otcl-1.11-badfreefix.patch
	EPATCH_OPTS="-p1 -d${S}" epatch ${FILESDIR}/otcl-1.11-configure-cleanup.patch

	cd ${S}
	eautoconf
	elibtoolize
	libtoolize -f
}

src_compile() {
	local tclv tkv myconf
	tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
	tkv=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
	myconf="--with-tcl-ver=${tclv} --with-tk-ver=${tkv}"
	CFLAGS="${CFLAGS} -I/usr/$(get_libdir)/tcl${tkv}/include/generic"

	echo myconf $myconf
	econf ${myconf} || die "econf failed"
	emake all || die "emake all failed"
	emake libotcl.so || die  "emake libotcl.so failed"
}

src_install() {
	dobin otclsh owish
	dolib libotcl.so
	dolib.a libotcl.a
	insinto /usr/include
	doins otcl.h

	# docs
	dodoc VERSION
	dohtml README.html CHANGES.html
	docinto doc
	dohtml doc/*.html
}

src_test() {
	Xmake test
}
