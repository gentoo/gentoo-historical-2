# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-1.9.94.ebuild,v 1.4 2006/10/30 19:07:40 alonbl Exp $

WANT_AUTOMAKE='latest'

inherit eutils flag-o-matic autotools

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/alpha/gnupg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.9"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="X gpg2-experimental doc ldap nls openct pcsc-lite smartcard selinux"

COMMON_DEPEND="
	virtual/libc
	>=dev-libs/pth-1.3.7
	>=dev-libs/libgcrypt-1.1.94
	>=dev-libs/libksba-0.9.15
	>=dev-libs/libgpg-error-1.4
	>=dev-libs/libassuan-0.9.3
	pcsc-lite? ( >=sys-apps/pcsc-lite-1.3.0 )
	openct? ( >=dev-libs/openct-0.5.0 )
	ldap? ( net-nds/openldap )"
# Needs sh and arm to be keyworded on pinentry
#	X? ( app-crypt/pinentry )

DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
	doc? ( sys-apps/texinfo )"

RDEPEND="${COMMON_DEPEND}
	!app-crypt/gpg-agent
	=app-crypt/gnupg-1.4*
	X? ( || ( media-gfx/xloadimage media-gfx/xli ) )
	virtual/mta
	selinux? ( sec-policy/selinux-gnupg )
	nls? ( virtual/libintl )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's/PIC/__PIC__/g' intl/relocatable.c || die "PIC patching failed"

	# this warning is only available on gcc4!
	sed -i -e '/AM_CFLAGS/s!-Wno-pointer-sign!!g' ${S}/g10/Makefile.am
	sed -i -e '/AM_CFLAGS/s!-Wno-pointer-sign!!g' ${S}/g10/Makefile.in

	epatch "${FILESDIR}/${P}-fbsd.patch"
	AT_M4DIR="m4 gl/m4" eautoreconf
}

src_compile() {
	local myconf=""

	if use X; then
		local viewer
		if has_version 'media-gfx/xloadimage'; then
			viewer=/usr/bin/xloadimage
		else
			viewer=/usr/bin/xli
		fi
		myconf="${myconf} --with-photo-viewer=${viewer}"
	else
		myconf="${myconf} --disable-photo-viewers"
	fi

	append-ldflags $(bindnow-flags)

	econf \
		--enable-agent \
		--enable-symcryptrun \
		$(use_enable gpg2-experimental gpg) \
		--enable-gpgsm \
		$(use_enable smartcard scdaemon) \
		$(use_enable nls) \
		$(use_enable ldap) \
		--disable-capabilities \
		${myconf} \
		|| die
	emake || die
	if use doc; then
		cd doc
		emake html || die
	fi
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README THANKS TODO VERSION

	# neither of these should really be needed, please check
	use gpg2-experimental && fperms u+s,go-r /usr/bin/gpg2
	fperms u+s,go-r /usr/bin/gpg-agent

	use doc && dohtml doc/gnupg.html/* doc/*jpg doc/*png
}

pkg_postinst() {
	einfo
	einfo "See http://www.gentoo.org/doc/en/gnupg-user.xml for documentation on gnupg"
	einfo
}
