# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ices/ices-0.2.3.ebuild,v 1.10 2004/06/24 23:49:41 agriffis Exp $

IUSE="oggvorbis perl"

inherit eutils

DESCRIPTION="icecast MP3 streaming client. supports on the fly re-encoding"
SRC_URI="http://www.icecast.org/releases/${P}.tar.gz"
HOMEPAGE="http://www.icecast.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc "

RDEPEND="net-misc/icecast
	media-sound/lame
	oggvorbis? ( >=media-libs/libvorbis-1.0 )"

DEPEND="${RDEPEND}
	sys-apps/sed"

src_unpack ()
{
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/docdir.diff
}

src_compile ()
{
	local myconf
	#use python && myconf="--with-python-includes=/usr/include/python2.2/"
	use perl && myconf=${myconf}" --with-perl"

	use oggvorbis \
		&& myconf="${myconf} --with-vorbis=/usr/lib"

	econf \
		--sysconfdir=/etc/ices \
		--with-lame \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install ()
{

	make DESTDIR=${D} install || die "make install failed"

}
