# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wget/wget-1.9-r2.ebuild,v 1.12 2005/01/09 11:31:48 swegener Exp $

inherit gnuconfig eutils

IUSE="build debug ipv6 nls socks5 ssl static"

PATCHVER=0.1
DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="http://wget.sunsite.dk/"
SRC_URI="mirror://gnu/wget/${P}.tar.gz
	mirror://gentoo/${P}+ipvmisc-${PATCHVER}.patch"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha hppa mips amd64 ia64"

RDEPEND="ssl? ( >=dev-libs/openssl-0.9.6b )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	sys-devel/autoconf"


src_unpack() {
	unpack ${P}.tar.gz
	epatch ${DISTDIR}/${P}+ipvmisc-${PATCHVER}.patch
	epatch ${FILESDIR}/${P}-uclibc.patch
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
