# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mutt/mutt-1.3.28.ebuild,v 1.9 2002/12/09 04:33:14 manson Exp $

IUSE="ssl nls slang"

S=$WORKDIR/${P}
DESCRIPTION="a small but very powerful text-based mail client"
SRC_URI="ftp://ftp.mutt.org/pub/mutt/mutt-${PV}i.tar.gz"
HOMEPAGE="http://www.mutt.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND=">=sys-libs/ncurses-5.2 
	ssl? ( >=dev-libs/openssl-0.9.6 )
	slang? ( >=sys-libs/slang-1.4.2 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf
	use nls && myconf="--enable-nls" \
		|| myconf="--disable-nls"
	use ssl && myconf="$myconf --with-ssl" \
		|| myconf="$myconf --without-ssl"
	# --without-slang doesn't work;
	# specify --with-curses if you don't want slang
	# (26 Sep 2001 agriffis)
	use slang && myconf="$myconf --with-slang" \
	          || myconf="$myconf --with-curses"
	./configure --host=$CHOST \
		--prefix=/usr --sysconfdir=/etc/mutt \
		--mandir=/usr/share/man --with-docdir=/usr/share/doc/mutt-$PVR \
		--with-regex --enable-pop --enable-imap --enable-nfs-fix \
		--with-homespool=Maildir $myconf
	assert "./configure failed (myconf=$myconf)"
	cp doc/Makefile doc/Makefile.orig
	sed 's/README.UPGRADE//' doc/Makefile.orig > doc/Makefile
	make || die "make failed (myconf=$myconf)"
}

src_install () {
	make DESTDIR=$D install || die
	find $D/usr/share/doc -type f |grep -v html | xargs gzip
	insinto /etc/mutt
	doins $FILESDIR/Muttrc

	dodoc BEWARE COPYRIGHT ChangeLog GPL INSTALL NEWS OPS* PATCHES README* \
		TODO VERSION
}
