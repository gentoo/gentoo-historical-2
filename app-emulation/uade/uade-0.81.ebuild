# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/uade/uade-0.81.ebuild,v 1.6 2004/06/15 03:19:49 mr_bones_ Exp $

DESCRIPTION="Unix Amiga Delitracker Emulator - plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API"
HOMEPAGE="http://uade.ton.tut.fi/"
SRC_URI="http://uade.ton.tut.fi/uade/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="xmms sdl"

RDEPEND="dev-lang/perl
	xmms? ( >=media-sound/xmms-1.2.2 x11-libs/gtk+ )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e 's:\$prefix/doc:/usr/share/doc:' configure \
		|| die 'sed configure failed'
}

src_compile() {
	local myconf="--package-prefix=${D}"

	use sdl	&& myconf="$myconf --with-sdl"
	use xmms || myconf="$myconf --no-plugin"

	econf ${myconf} || die
	# warning...broken Makefiles ahead.
	emake -j1 || die 'emake failed'
}

src_install() {
	make DESTDIR="${D}" install || die 'make install failed'

	# make install doesn't put anything in this directory
	# I assume it's necessary to have it around so use keepdir to make is so.
	keepdir /usr/share/uade/players/S

	dodoc BUGS ChangeLog.txt FIXED
	find "${D}/usr/share/doc/${PF}/" \
		\( -name '*.readme'	-o \
		-name '*.txt'		-o \
		-name 'INSTALL*'	-o \
		-name 'README*'		-o \
		-name 'Change*'	\) -exec gzip -9 \{\} \;
	dohtml "${D}/usr/share/doc/${PF}/"{*.html,*.png} || die 'dohtml failed'
	rm -f "${D}/usr/share/doc/${PF}/"{COPYING*,*.html,*.png}
}
