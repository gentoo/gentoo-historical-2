# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/coda/coda-6.9.4.ebuild,v 1.2 2010/01/20 13:37:33 george Exp $

inherit autotools eutils toolchain-funcs

IUSE="client server coda_layout coda_symlinks kerberos"
# client        : causes the coda client (venus) to be built.
# server        : causes the coda server (vice) to be built.
# coda_layout   : doesn't apply FHS compliancy patches. Use this if using any directory
#     other than /coda for the mount point makes you upset.
# coda_symlinks : create legacy symlinks if FHS layout is used.

DESCRIPTION="Coda is an advanced networked filesystem developed at Carnegie Mellon Univ."
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/coda/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

# partly based on the deps suggested by Mandrake's RPM, and/or on my current versions
# Also, definely needs coda.h from linux-headers.
RDEPEND=">=sys-libs/lwp-2.1
	>=net-libs/rpc2-2.6
	>=sys-libs/rvm-1.15
	>=sys-libs/db-3
	>=sys-libs/ncurses-4
	>=sys-libs/readline-3
	>=dev-lang/perl-5.8
	kerberos? ( virtual/krb5 )"

DEPEND="${RDEPEND}
	sys-apps/gawk
	sys-devel/bison
	sys-apps/grep
	virtual/os-headers"

pkg_setup() {
	echo
	einfo "gcc-version = $(gcc-version)"
	echo

	if [[ "$(gcc-version)" > "4.3" ]]; then
		ewarn
		eerror "coda needs gcc < 4.4 to build cleanly"
		ewarn
		die "coda needs gcc < 4.4 to build cleanly"
	fi

	if ! use client && ! use server; then
		eerror "Neither client nor server is enabled."
		eerror "Please enable at least one of these flags!"
		die "at  least one of client or server flags should be on!"
	fi

	if ! use coda_layout; then
		einfo
		ewarn "FHS compliancy is selected!"
		ewarn "There is nothing wrong with this, however this is still a special"
		ewarn "modification to coda code and settings."
		ewarn "If you are unsire, please add coda_layout to use flags of net-fs/coda"
		ewarn "and restart the emerge."
		einfo
		sleep 5
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	tar xjpf "${FILESDIR}"/scripts.tar.bz2
	epatch "${FILESDIR}"/fixdeps.patch
	epatch "${FILESDIR}"/gentoo-init.patch

	if ! use coda_layout; then
		einfo "seding sources.."
		# First, some common substitutions.
		# As this is a rather critical subsystem and screwing paths can break
		# user's data, protect all seds by die.
		#
		# NOTE: gentoo  specific init scripts installed as a part of unpack ${A}
		# have some paths specified inside. However these will be autoupdated by
		# below seds for free, no need for special care.
		#
		# first, special cases under /usr/coda
		# for spool, look only in subdirs, as we do not want to touch ChangeLog
		grep -rl "/usr/coda/spool" "${S}"/*/* | xargs \
			sed -i -e "s:/usr/coda/spool:/var/spool/coda:" \
			|| die "setting FHS compliant paths failed"

		# coda/etc used to contain vstab file, which normally would reside in
		# /etc/coda. However this file was deprecated, so no special handling..
		# do only subdirs here too.
		grep -rl "/usr/coda/etc" "${S}"/*/*   | xargs \
			sed -i -e "s:/usr/coda/etc:/var/log/coda:" \
			|| die "setting FHS compliant paths failed"

		grep -rl "/usr/coda/venus.cache" "${S}"/* | xargs \
			sed -i -e "s:/usr/coda/venus.cache:/var/cache/coda:" \
			|| die "setting FHS compliant paths failed"

		# what's left in /usr/coda goes to /var/lib/coda
		# NOTE: dumplits.5 man page seems unduly touched by this sed, ignoring
		# for now..
		grep -rl "/usr/coda" "${S}"/*/*   | xargs \
			sed -i -e "s:/usr/coda:/var/lib/coda:" \
			|| die "setting FHS compliant paths failed"

		# move /coda to /mnt/coda
		grep -rle "[[:space:]\"=]/coda" "${S}"/*/*   | xargs \
			sed -i -e "s:\([[:space:]\"=]\)/coda:\1/mnt/coda:" \
			|| die "setting FHS compliant paths failed"

		# move /vice and /vicepX under /var/lib/coda/
		grep -rle "[[:space:]\"=\[]/vice" "${S}"/*/*   | xargs \
			sed -i -e "s:\([[:space:]\"=\[]\)/vice:\1/var/lib/coda/vice:g" \
			|| die "setting FHS compliant paths failed"
	fi

	eautoreconf
}

my_build_venus_prereqs() {
	# Coda uses a recursive make with some directories depending
	# on objects built in other directories, so run make inside
	# the prerequisite dirs first. This builds everything required
	# by venus in the order listed in coda-src/Makefile.am.

	cd "${S}/lib-src"
	emake || die "emake failed"

	# auth2 depends on kerndep
	cd "${S}/coda-src/kerndep"
	emake || die "emake failed"

	# auth2 depends on util.
	cd "${S}/coda-src/util"
	emake || die "emake failed"

	# librepair depends on vicedep
	cd "${S}/coda-src/vicedep"
	emake || die "emake failed"

	# venus depends on dir
	cd "${S}/coda-src/dir"
	emake || die "emake failed"

	# venus depends on al
	cd "${S}/coda-src/al"
	emake || die "emake failed"

	# librepair depends on auth2
	cd "${S}/coda-src/auth2"
	emake || die "emake failed"

	# venus depends on vv
	cd "${S}/coda-src/vv"
	emake || die "emake failed"

	# venus depends on lka
	cd "${S}/coda-src/lka"
	emake || die "emake failed"

	# venus depends on vol
	cd "${S}/coda-src/vol"
	emake || die "emake failed"

	# venus depends on librepair
	cd "${S}/coda-src/librepair"
	emake || die "emake failed"
}

src_compile() {
	local myflags=""

	# Coda uses type punning in a way that violates assumptions made by -O2
	# and friends (via -fstrict-aliasing). Disable this optimization where
	# required.
	local my_safe_cflags="${CFLAGS} -fno-strict-aliasing"
	local my_safe_cxxflags="${CXXFLAGS} -fno-strict-aliasing"

	# Include the server/client code.
	use client && myflags="${myflags} --enable-client"
	use server && myflags="${myflags} --enable-server"

	# Enable kerboeros?
	if use kerberos; then
		myflags="${myflags} --with-crypto --with-krb5"
		myflags="${myflags} --with-krb5-includes=/usr/include/krb5"
		myflags="${myflags} --with-krb5-libs=/usr/lib"
	fi

	# Perform the actual configure.
	econf ${myflags} || die "configure failed"

	# Build any prerequisites for venus.
	my_build_venus_prereqs

	# Venus uses unsafe type punning, so disable
	# some optimizations for venus.
	pushd coda-src/venus
	emake \
		CFLAGS="${my_safe_cflags}" \
		CXXFLAGS="${my_safe_cxxflags}" \
		|| die "emake failed"
	popd

	# Now run make in the source directory to finish the compile.
	emake -j1 || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc INSTALL* README* NEWS ChangeLog AUTHORS

	use server && doinitd coda-src/scripts/codasrv
	use client && doinitd coda-src/scripts/venus

	# Fix conflict with backup.sh from tar
	mv -f "${D}"/usr/sbin/backup{,-coda}.sh

	if use coda_layout; then
		# Create coda specific layout
		dodir /usr/coda
		dodir /usr/coda/etc
		dodir /usr/coda/spool
		if use server; then
			dodir /vice
			dodir /vicepa
		fi
		if use client; then
			dodir /coda
			diropts -m0700
			dodir /usr/coda/venus.cache
		fi
	else
		# Create FHS compliant layout
		dodir /var/lib/coda
		dodir /var/log/coda
		dodir /var/spool/coda

		if use server; then
			dodir /var/lib/coda/vice
			dodir /var/lib/coda/vicepa
		fi

		if use client; then
			dodir /mnt/coda
			dosym mnt/coda /coda
			diropts -m0700
			dodir /var/cache/coda
		fi

		if use coda_symlinks; then
			# Symlink traditional coda dirs to gentoo dirs.
			# NOTE: /coda symlink is unconditional for compatibility of client apps
			dosym ../var/lib/coda /usr/coda
			if use server; then
				dosym var/lib/coda/vice /vice
				dosym var/lib/coda/vicepa /vicepa
			fi
		fi
	fi
}

pkg_preinst () {
	enewgroup codaroot
	enewuser codaroot -1 -1 -1 codaroot
}

pkg_postinst () {
	einfo
	elog "To enable the coda server at boot up, please do:"
	elog "    rc-update add codasrv default"
	elog
	elog "To enable the coda client at boot up, do:"
	elog "    rc-update add venus default"
	elog
	elog "To get started, run vice-setup and/or venus-setup."
	einfo
}
