# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/easytag/easytag-0.23.ebuild,v 1.5 2003/02/19 19:24:01 seemant Exp $

IUSE="nls oggvorbis"

S=${WORKDIR}/${P}
DESCRIPTION="EasyTAG mp3/ogg tag editor"
SRC_URI="mirror://sourceforge/easytag/${P}.tar.gz"
HOMEPAGE="http://easytag.sourceforge.net/"

RDEPEND="=x11-libs/gtk+-1.2*
		 >=media-libs/id3lib-3.7.13
		 oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
	
DEPEND="${RDEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~hppa"

src_compile() {
	local myconf

	use oggvorbis ||  myconf="--disable-ogg"
	use nls || myconf="${myconf} --disable-nls"
	
	econf ${myconf} || die
	emake || die
}

src_install() {							   
	make \
		prefix=${D}/usr \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		sysconfdir=${D}/etc \
		sysdir=${D}/usr/share/applets/Multimedia \
		GNOME_SYSCONFDIR=${D}/etc \
		install || die

	dodoc ChangeLog COPYING NEWS README TODO THANKS USERS-GUIDE
	
}
