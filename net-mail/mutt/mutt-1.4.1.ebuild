# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mutt/mutt-1.4.1.ebuild,v 1.1 2003/03/22 04:02:52 pylon Exp $

IUSE="ssl nls slang cjk"

S=$WORKDIR/${P}
DESCRIPTION="a small but very powerful text-based mail client"
SRC_URI="ftp://ftp.mutt.org/mutt/mutt-${PV}i.tar.gz
	http://www.spinnaker.de/mutt/compressed/patch-${PV}.rr.compressed.1.gz
	cjk?( http://www.emaillab.org/mutt/1.4/mutt-${PV}i-ja.1.tar.gz )
	http://cedricduval.free.fr/download/mutt/patch-1.4.0.cd.edit_threads.9.5"
HOMEPAGE="http://www.mutt.org"

DEPEND=">=sys-libs/ncurses-5.2
	ssl? ( >=dev-libs/openssl-0.9.6 )
	slang? ( >=sys-libs/slang-1.4.2 )"

RDEPEND="nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc"

inherit flag-o-matic

src_unpack() {
	unpack ${P}i.tar.gz
	if [ "`use cjk`" ]; then
		unpack ${P}i-ja.1.tar.gz
		cd ${S}
		patch -p1 < ../mutt-1.4i-ja.1/patch-1.4.tt.ja.1 || die
	fi

	zcat ${DISTDIR}/patch-${PV}.rr.compressed.1.gz | patch -d ${S} -p1 || die
	patch -d ${S} -p1 < ${DISTDIR}/patch-1.4.0.cd.edit_threads.9.5 || die
}

src_compile() {
	# See Bug #11170
	if [ "${ARCH}" = "ppc" ]
	then
		replace-flags "-O[3-9]" "-O2"
	fi

	local myconf
	use nls \
		&& myconf="--enable-nls" \
		|| myconf="--disable-nls"

	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl"

	# --without-slang doesn't work;
	# specify --with-curses if you don't want slang
	# (26 Sep 2001 agriffis)

	use slang \
		&& myconf="${myconf} --with-slang" \
		|| myconf="${myconf} --with-curses"

	use cjk && myconf="$myconf --enable-default-japanese"

	econf \
		--sysconfdir=/etc/mutt \
		--with-docdir=/usr/share/doc/mutt-$PVR \
		--with-regex --enable-pop --enable-imap --enable-nfs-fix \
		--disable-fcntl --enable-flock --enable-external-dotlock \
		--with-homespool=Maildir \
		--enable-compressed \
		--enable-imap-edit-threads \
		${myconf} || die

	cp doc/Makefile doc/Makefile.orig
	sed 's/README.UPGRADE//' doc/Makefile.orig > doc/Makefile
	make || die "make failed (myconf=${myconf})"
}

src_install () {
	make DESTDIR=$D install || die
	find $D/usr/share/doc -type f |grep -v html | xargs gzip
	insinto /etc/mutt
	if [ "`use mbox`" ]; then
		echo "Not installing an /etc/Muttrc as mbox is default configuration"
		echo "with mutt"
	else
		doins $FILESDIR/Muttrc
	fi

	dodoc BEWARE COPYRIGHT ChangeLog NEWS OPS* PATCHES README* TODO VERSION
}
