# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nam/nam-1.10.ebuild,v 1.10 2009/03/20 20:16:04 jmbsvicetto Exp $

DESCRIPTION="Network Simulator GUI for NS"
HOMEPAGE="http://www.isi.edu/nsnam/${PN}/"
SRC_URI="http://www.isi.edu/nsnam/dist/${PN}-src-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE="debug"
need_tclver="8.4.4"
valid_tclver="${need_tclver}"
mytclver=""
DEPEND="x11-libs/libXmu
		>=dev-lang/tcl-${need_tclver}
		>=dev-lang/tk-${need_tclver}
		>=dev-tcltk/otcl-1.0.8a
		>=dev-tcltk/tclcl-1.0.13b
		dev-tcltk/tcl-debug"
RDEPEND=">=net-analyzer/ns-2.27
		 ${DEPEND}"

findtclver() {
	# input should always be in INCREASING order
	local ACCEPTVER="8.3 8.4"
	[ -n "$*" ] && ACCEPTVER="$*"
	for i in ${ACCEPTVER}; do
		use debug && einfo "Testing TCL ${i}"
		has_version ">=dev-lang/tcl-${i}" && mytclver=${i}
	done
	use debug && einfo "Using TCL ${mytclver}"
	if [ -z "${mytclver}" ]; then
		die "Unable to find a suitable version of TCL"
	fi
}

src_compile() {
	local myconf
	findtclver ${valid_tclver}
	myconf="${myconf} --with-tcl-ver=${mytclver} --with-tk-ver=${mytclver}"

	econf ${myconf} \
	--mandir=/usr/share/man \
	--enable-stl \
	--enable-release \
	|| die "./configure failed"
	emake || die
}

src_install() {
	dodir /usr/bin
	make DESTDIR="${D}" install || die
	dohtml CHANGES.html TODO.html
	dodoc FILES VERSION INSTALL.WIN32 README
	cp -ra ex "${D}/usr/share/doc/${PF}/examples"
	cp -ra iecdemos edu "${D}/usr/share/doc/${PF}"
	doman nam.1
}
