# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/vdk/vdk-2.4.0.ebuild,v 1.3 2004/10/14 17:46:36 mr_bones_ Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A Visual Development Kit for RAD"
SRC_URI="mirror://sourceforge/vdkbuilder/${P}.tar.gz"
HOMEPAGE="http://vdk.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa"
IUSE="doc debug"

DEPEND=">x11-libs/gtk+-2.4*
	doc? ( app-doc/doxygen )"

src_compile() {

	cd ${S}

	local myconf=""

	if [ "$(gcc-major-version)" -ge "4" ] || [ "$(gcc-major-version)" -ge "3" -a "$(gcc-minor-version)" -ge "4" ]
	then
		epatch ${FILESDIR}/${P}-gcc3.4.patch
	fi

	# gnome and sigc USE flags need to be added later
	# when upstream decides to re-support them - ChrisWhite

	use doc && \
		myconf="${myconf} --enable-doc-html=yes \
						  --enable-doc-latex=yes \
						  --enable-doc-man=yes" \
		|| myconf="${myconf} --enable-doc-html=no \
							 --enable-doc-latex=no \
							 --enable-doc-man=no"

	use debug && \
		myconf="${myconf} --enable-debug=yes" \
		|| myconf="${myconf} --enable-debug=no"

	econf \
		${myconf} \
		--with-gnu-ld \
		--enable-testvdk=no \
		|| die "econf failed"

		# die non user custom CFLAGS!
		sed -e "s/CFLAGS = .*/CFLAGS = ${CFLAGS}/" -i Makefile
		sed -e "s/CXXFLAGS = .*/CXXFLAGS = ${CXXFLAGS}/" -i Makefile
		sed -e "s/CFLAGS = .*/CFLAGS = ${CFLAGS}/" -i vdk/Makefile
		sed -e "s/CXXFLAGS = .*/CXXFLAGS = ${CXXFLAGS}/" -i vdk/Makefile

		emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README TODO
}
