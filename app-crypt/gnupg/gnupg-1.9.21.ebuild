# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-1.9.21.ebuild,v 1.8 2006/10/01 12:26:18 dertobi123 Exp $

inherit eutils flag-o-matic autotools

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/alpha/gnupg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.9"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 s390 sh sparc ~x86 ~x86-fbsd"
IUSE="X gpg2-experimental ldap nls smartcard selinux"
#IUSE+=caps

COMMON_DEPEND="
	dev-lang/perl
	sys-libs/zlib
	virtual/libc
	>=dev-libs/pth-1.3.7
	smartcard? ( >=dev-libs/opensc-0.8.0 )
	>=dev-libs/libgcrypt-1.1.94
	>=dev-libs/libksba-0.9.15
	>=dev-libs/libgpg-error-1.0
	~dev-libs/libassuan-0.6.10
	ldap? ( net-nds/openldap )"
#	caps? ( sys-libs/libcap )"

DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"

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
	if use smartcard && ! built_with_use dev-libs/opensc pcsc-lite ; then
		sed -i -e 's:OPENSC_LIBS="\$OPENSC_LIBS -lpcsclite -lpthread":OPENSC_LIBS="\$OPENSC_LIBS -lopenct -lpthread":' \
		acinclude.m4 || die "openct patching failed."
		./autogen.sh
	fi
	sed -i -e 's/PIC/__PIC__/g' intl/relocatable.c || die "PIC patching failed"

	# this warning is only available on gcc4!
	sed -i -e '/AM_CFLAGS/s!-Wno-pointer-sign!!g' ${S}/g10/Makefile.am
	sed -i -e '/AM_CFLAGS/s!-Wno-pointer-sign!!g' ${S}/g10/Makefile.in

	epatch "${FILESDIR}/${PN}-1.9.20-fbsd.patch"
	#epatch "${FILESDIR}/${P}-fbsd-gcc41.patch"
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

	#use caps || append-ldflags $(bindnow-flags)
	append-ldflags $(bindnow-flags)

	#$(use_with caps capabilities) \
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
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README THANKS TODO VERSION

	#if ! use caps; then
		use gpg2-experimental && fperms u+s,go-r /usr/bin/gpg2
		fperms u+s,go-r /usr/bin/gpg-agent
	#fi
}

pkg_postinst() {
	#if ! use caps; then
	#	einfo "gpg is installed suid root to make use of protected memory space"
	#	einfo "This is needed in order to have a secure place to store your"
	#	einfo "passphrases, etc. at runtime but may make some sysadmins nervous."
	#fi
	einfo
	einfo "See http://www.gentoo.org/doc/en/gnupg-user.xml for documentation on gnupg"
	einfo
}
