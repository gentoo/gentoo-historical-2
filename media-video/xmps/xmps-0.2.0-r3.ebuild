# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xmps/xmps-0.2.0-r3.ebuild,v 1.1 2003/03/05 01:34:21 pfeifer Exp $

IUSE="nls gnome"

S=${WORKDIR}/${P}
DESCRIPTION="X Movie Player System"
SRC_URI="http://xmps.sourceforge.net/sources/${P}.tar.gz"
HOMEPAGE="http://xmps.sourceforge.net"

DEPEND="=x11-libs/gtk+-1.2*
	x86? ( >=dev-lang/nasm-0.98 )
	>=dev-libs/popt-1.5
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )"

RDEPEND=">=media-libs/smpeg-0.4.4-r1
	nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"


src_unpack() {
	unpack ${A}

	# Fixes compile issues on motion_comp.c (Bug #2822)
	cd ${S}
	patch -p1 < ${FILESDIR}/xmps-0.2.0_motion_comp.c.gentoo.diff || die
}

src_compile() {

	local myconf

	use gnome && myconf="--enable-gnome"

	use nls || myconf="${myconf} --disable-nls"

	econf ${myconf} || die "econf failed"

	for file in `find . -iname "Makefile"`;do
		mv ${file} ${file}.orig
		sed -e "s:-Werror::g;s:-ldb1:-ldb:g" \
			${file}.orig > ${file} || die "sed-fu failed"
	done

	mv intl/l10nflist.c intl/l10nflist.c.orig
	sed -e "s:\(#ifdef HAVE_CONFIG_H\):#define _LIBC 1\n\1:" \
		intl/l10nflist.c.orig > intl/l10nflist.c

	mv Makefile Makefile.orig
	sed -e "s:\$(bindir)/xmps-config:\$(DESTDIR)\$(bindir)/xmps-config:" \
		Makefile.orig > Makefile

	emake || die "emake failed"

}

src_install () {

	einstall || die "einstall failed"

	dodoc AUTHORS ChangeLog COPYING NEWS README TODO

}
