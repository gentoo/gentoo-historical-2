# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg/gnupg-1.4.0-r1.ebuild,v 1.2 2005/01/06 10:44:40 eradicator Exp $

inherit eutils flag-o-matic

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/gnupg/${P}.tar.bz2
	idea? ( ftp://ftp.gnupg.dk/pub/contrib-dk/idea.c.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm -hppa ~ppc ~ppc-macos ~s390 -sparc ~x86 ~ia64 ~mips ~ppc64"
IUSE="ldap nls readline caps zlib idea bzip2 selinux"
#static not working yet
#
# Disabling X and usb until dependancies has sufficient keywords
# X
# smartcard

#!static? (
#			ldap? ( net-nds/openldap )
#			bzip2? ( app-arch/bzip2 )
#			zlib? ( sys-libs/zlib )
#		)

RDEPEND="
	ldap? ( net-nds/openldap )
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	nls? ( sys-devel/gettext )
	virtual/libc
	readline? ( sys-libs/readline )"


#	X? ( media-gfx/xloadimage media-gfx/xli )
#	smartcard? ( dev-libs/libusb )

# 	dev-lang/perl
#	virtual/mta


DEPEND="ldap? ( net-nds/openldap )
	nls? ( sys-devel/gettext )
	zlib? ( sys-libs/zlib )
	bzip2? ( app-arch/bzip2 )
	dev-lang/perl
	virtual/libc"

#	smartcard? ( dev-libs/libusb )

src_unpack() {
	unpack ${A}
	# Please read http://www.gnupg.org/why-not-idea.html
	if use idea; then
		mv ${WORKDIR}/idea.c ${S}/cipher/idea.c || \
			ewarn "failed to insert IDEA module"
	fi
	cd ${S}
	sed -i -e 's:PIC:__PIC__:' mpi/i386/mpih-{add,sub}1.S intl/relocatable.c
	sed -i -e 's:if PIC:ifdef __PIC__:' mpi/sparc32v8/mpih-mul{1,2}.S
}

src_compile() {
	# Certain sparc32 machines seem to have trouble building correctly with 
	# -mcpu enabled.  While this is not a gnupg problem, it is a temporary
	# fix until the gcc problem can be tracked down.
	if [ "${ARCH}" == "sparc" ] && [ "${PROFILE_ARCH}" == "sparc" ]; then
		filter-flags -mcpu=supersparc -mcpu=v8 -mcpu=v7
	fi

	# `USE=static` support was requested in #29299
	# use static && append-ldflags -static

	# Still needed?
	# Bug #6387, --enable-m-guard causes bus error on sparcs
	use sparc || myconf="${myconf} --enable-m-guard"

	if ! use zlib; then
		myconf="${myconf} --with-included-zlib"
	else
		myconf="${myconf} --without-included-zlib"
	fi

	use ppc-macos || append-ldflags -Wl,-z,now

	if use ppc-macos && use caps; then
		eerror "Capabilities support is only available for Linux."
	fi

	econf \
		`use_enable X photo-viewers` \
		`use_enable ldap` \
		--enable-mailto \
		--enable-hkp \
		--enable-finger \
		`use_enable nls` \
		`use_enable bzip2` \
		`use_enable smartcard card-support` \
		`use_enable selinux selinux-support` \
		`use_enable x86 asm` \
		`use_with caps capabilities` \
		`use_with readline` \
		--enable-static-rnd=linux \
		--libexecdir=/usr/libexec \
		--enable-sha512 \
		${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} libexecdir="/usr/libexec/gnupg" install || die

	# keep the documentation in /usr/share/doc/...
	rm -rf "${D}/usr/share/gnupg/FAQ" "${D}/usr/share/gnupg/faq.html"

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS PROJECTS README THANKS \
		TODO VERSION doc/{FAQ,HACKING,DETAILS,ChangeLog,OpenPGP,faq.raw}

	docinto sgml
	dodoc doc/*.sgml

	dohtml doc/faq.html
}

