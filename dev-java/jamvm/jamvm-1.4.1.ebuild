# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jamvm/jamvm-1.4.1.ebuild,v 1.1 2005/12/21 17:32:57 betelgeuse Exp $

inherit eutils flag-o-matic

DESCRIPTION="An extremely small and specification-compliant virtual machine."
HOMEPAGE="http://jamvm.sourceforge.net/"
SRC_URI="mirror://sourceforge/jamvm/jamvm-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=dev-java/gnu-classpath-0.19"
RDEPEND="${DEPEND}"

src_compile() {
	filter-flags "-fomit-frame-pointer"

	# configure adds "/share/classpath" itself
	local myc="--with-classpath-install-dir=/usr"
	use debug && myc="${myc} --enable-tracelock"
	econf ${myc} || die "configure failed."
	emake || die "make failed."
}

src_install() {
	make install-strip DESTDIR="${D}" || die "installation failed."

	# puts jni.h in a package dependent folder
	cd "${D}/usr/include"
	mkdir ${PN}
	mv jni.h ${PN} || die "moving jni.h to package dependet folder failed"

	cd "${S}"
	dodoc ACKNOWLEDGEMENTS AUTHORS ChangeLog NEWS README \
		|| die "dodoc failed"
}

