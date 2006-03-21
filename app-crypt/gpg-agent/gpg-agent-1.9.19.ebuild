# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpg-agent/gpg-agent-1.9.19.ebuild,v 1.5 2006/03/21 04:26:53 agriffis Exp $

inherit eutils flag-o-matic

# gpg-agent is took from gnupg package.
GPG_P=gnupg-${PV}
S=${WORKDIR}/${GPG_P}

DESCRIPTION="The GNU Privacy Guard Agent"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/alpha/gnupg/${GPG_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

IUSE="caps nls smartcard"

COMMON_DEPEND="app-crypt/gnupg
	>=dev-libs/libassuan-0.6.10
	caps? ( sys-libs/libcap )
	>=dev-libs/libgpg-error-1.0
	>=dev-libs/libgcrypt-1.1.94
	>=dev-libs/libksba-0.9.12
	smartcard? ( >=dev-libs/opensc-0.8.0 )
	>=dev-libs/pth-1.3.7"

RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	nls? ( sys-devel/gettext )"

src_compile() {
	# We install +s only if USE=-caps

	if ! use caps
	then
		append-ldflags $(bindnow-flags)
	fi
	econf \
		--enable-agent-only \
		--disable-scdaemon \
		--disable-gpgsm \
		--enable-symcryptrun \
		$(use_enable nls) \
		$(use_with caps capabilities) \
		|| die
	emake || die
}

src_test() {
	ewarn "self test is broken"
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc README

	if ! use caps ; then
		fperms u+s,go-r /usr/bin/gpg-agent
	fi
}

pkg_postinst() {
	ewarn "** WARNING ** WARNING ** WARNING ** WARNING ** WARNING ** WARNING **"
	ewarn " THIS IS _ALPHA_ CODE, IT MAY NOT WORK CORRECTLY OR AT ALL. THERE"
	ewarn " MAY BE UNDISCOVERED SECURITY OR DATA-LOSS ISSUES, DO NOT USE"
	ewarn " IN A PRODUCTION ENVIRONMENT."

	if ! use caps; then
		einfo "gpg is installed suid root to make use of protected memory space"
		einfo "This is needed in order to have a secure place to store your"
		einfo "passphrases, etc. at runtime but may make some sysadmins nervous."
	fi
	echo
}
