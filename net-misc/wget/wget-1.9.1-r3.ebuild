# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wget/wget-1.9.1-r3.ebuild,v 1.5 2005/03/03 00:26:50 j4rg0n Exp $

inherit gnuconfig eutils

NPVER=20031022
DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="http://wget.sunsite.dk/"
SRC_URI="mirror://gnu/wget/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ppc-macos ~s390 ~sh ~sparc ~x86"
IUSE="build debug ipv6 nls socks5 ssl static"

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.6b )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}+ipvmisc.patch
	epatch ${FILESDIR}/${PN}-1.9-uclibc.patch
	epatch ${FILESDIR}/${P}-locale.patch
	# security patch for bug 74008
	epatch ${FILESDIR}/${PN}-CAN-2004-1487.patch
}

src_compile() {
	# Make wget use up-to-date configure scripts
	gnuconfig_update

	local myconf
	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl --disable-opie --disable-digest"

	use ssl && CFLAGS="${CFLAGS} -I/usr/include/openssl"

	econf \
		--sysconfdir=/etc/wget \
		`use_enable ipv6` \
		`use_enable nls` \
		`use_enable debug` \
		`use_with socks5 socks` \
		${myconf} || die

	if use static; then
		emake LDFLAGS="--static" || die
	else
		emake || die
	fi
}

src_install() {
	if use build; then
		insinto /usr
		dobin ${S}/src/wget
		return
	fi
	make prefix=${D}/usr sysconfdir=${D}/etc/wget \
		mandir=${D}/usr/share/man infodir=${D}/usr/share/info install || die
	dodoc AUTHORS COPYING ChangeLog MACHINES MAILING-LIST NEWS README TODO
	dodoc doc/sample.wgetrc
}
