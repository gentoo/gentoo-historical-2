# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Ryan Phillips <rphillips@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/easytag/easytag-0.18.ebuild,v 1.2 2002/04/26 21:02:32 rphillips Exp $

S=${WORKDIR}/${P}
DESCRIPTION="EasyTAG mp3/ogg tag editor"
SRC_URI="http://prdownloads.sourceforge.net/easytag/${P}.tar.gz"
HOMEPAGE="http://easytag.sourceforge.net/"

RDEPEND=">=x11-libs/gtk+-1.2.10-r4
	     >=media-libs/id3lib-3.7.13
	     oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
	
DEPEND="${RDEPEND}"

src_compile() {
	local myconf
	if [ "use oggvorbis" ] ; then
		myconf="--enable-ogg"
	else
		myconf="--disable-ogg"
	fi
	
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man ${myconf} || die

	emake || die
}

src_install() {                               
	make prefix=${D}/usr 						\
	     mandir=${D}/usr/share/man					\
	     sysconfdir=${D}/etc					\
	     sysdir=${D}/usr/share/applets/Multimedia 			\
	     GNOME_SYSCONFDIR=${D}/etc					\
	     install || die

	dodoc AUTHORS ChangeLog COPYING FAQ NEWS README TODO 
	
}
