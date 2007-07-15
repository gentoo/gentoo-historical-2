# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-lib/freebsd-lib-6.2-r1.ebuild,v 1.4 2007/07/15 02:20:41 mr_bones_ Exp $

inherit bsdmk freebsd flag-o-matic toolchain-funcs

DESCRIPTION="FreeBSD's base system libraries"
SLOT="6.0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"

IUSE="atm bluetooth ssl ipv6 kerberos nis gpib build bootstrap"

# Crypto is needed to have an internal OpenSSL header
# sys is needed for libalias, probably we can just extract that instead of
# extracting the whole tarball
SRC_URI="mirror://gentoo/${LIB}.tar.bz2
		mirror://gentoo/${CONTRIB}.tar.bz2
		mirror://gentoo/${CRYPTO}.tar.bz2
		mirror://gentoo/${LIBEXEC}.tar.bz2
		mirror://gentoo/${ETC}.tar.bz2
		mirror://gentoo/${INCLUDE}.tar.bz2
		nis? ( mirror://gentoo/${USBIN}.tar.bz2 )
		build? (
			mirror://gentoo/${SYS}.tar.bz2 )"

if [[ ${CATEGORY/cross-} == ${CATEGORY} ]]; then
	RDEPEND="ssl? ( dev-libs/openssl )
		kerberos? ( virtual/krb5 )
		!sys-freebsd/freebsd-headers"
	DEPEND="${RDEPEND}
		>=sys-devel/flex-2.5.31-r2
		=sys-freebsd/freebsd-sources-${RV}*
		!bootstrap? ( app-arch/bzip2 )"

	PROVIDE="virtual/libc
		virtual/os-headers"

else
	SRC_URI="${SRC_URI}
			mirror://gentoo/${SYS}.tar.bz2"
fi

DEPEND="${DEPEND}
		=sys-freebsd/freebsd-mk-defs-${RV}*"

S="${WORKDIR}/lib"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} && ${CATEGORY/cross-} != ${CATEGORY} ]]; then
	export CTARGET=${CATEGORY/cross-}
fi

pkg_setup() {
	[[ -c /dev/zero ]] || \
		die "You forgot to mount /dev; the compiled libc would break."

	if ! use ssl && use kerberos; then
		eerror "If you want kerberos support you need to enable ssl support, too."
	fi

	use atm || mymakeopts="${mymakeopts} NO_ATM= "
	use bluetooth || mymakeopts="${mymakeopts} NO_BLUETOOTH= "
	use ssl || mymakeopts="${mymakeopts} NO_OPENSSL= NO_CRYPT= "
	use ipv6 || mymakeopts="${mymakeopts} NO_INET6= "
	use kerberos || mymakeopts="${mymakeopts} NO_KERBEROS= "
	use nis || mymakeopts="${mymakeopts} NO_NIS= "
	use gpib || mymakeopts="${mymakeopts} NO_GPIB= "

	mymakeopts="${mymakeopts} NO_OPENSSH= NO_BIND= NO_SENDMAIL= "

	if [[ ${CTARGET} != ${CHOST} ]]; then
		mymakeopts="${mymakeopts} MACHINE=$(tc-arch-kernel ${CTARGET})"
		mymakeopts="${mymakeopts} MACHINE_ARCH=$(tc-arch-kernel ${CTARGET})"
	fi
}

PATCHES="${FILESDIR}/${PN}-bsdxml.patch
	${FILESDIR}/${PN}-6.0-pmc.patch
	${FILESDIR}/${PN}-6.0-gccfloat.patch
	${FILESDIR}/${PN}-6.0-flex-2.5.31.patch
	${FILESDIR}/${PN}-6.0-binutils-asm.patch
	${FILESDIR}/${PN}-6.0-ssp.patch
	${FILESDIR}/${PN}-6.1-csu.patch
	${FILESDIR}/${PN}-6.2-gcc41.patch
	${FILESDIR}/${PN}-6.2-sparc64.patch"

# Here we disable and remove source which we don't need or want
# In order:
# - ncurses stuff
# - archiving libraries (have their own ebuild)
# - sendmail libraries (they are installed by sendmail)
# - SNMP library and dependency (have their own ebuilds)
#
# The rest are libraries we already have somewhere else because
# they are contribution.
# Note: libtelnet is an internal lib used by telnet and telnetd programs
# as it's not used in freebsd-lib package itself, it's pointless building
# it here.
REMOVE_SUBDIRS="libncurses libform libmenu libpanel libedit \
	libz libbz2 libarchive \
	libsm libsmdb libsmutil \
	libbegemot libbsnmp \
	libpam libpcap bind libwrap libmagic \
	libcom_err libtelnet"

src_unpack() {
	freebsd_src_unpack

	sed -i -e 's:-o/dev/stdout:-t:' "${S}/libc/net/Makefile.inc"
	sed -i -e 's:histedit.h::' "${WORKDIR}/include/Makefile"

	# Upstream Display Managers default to using VT7
	# We should make FreeBSD allow this by default
	local x=
	for x in "${WORKDIR}"/etc/etc.*/ttys ; do
		sed -i \
			-e '/ttyv5[[:space:]]/ a\
# Display Managers default to VT7.\
# If you use the xdm init script, keep ttyv6 commented out\
# unless you force a different VT for the DM being used.' \
			-e '/^ttyv[678][[:space:]]/ s/^/# /' "${x}" \
			|| die "Failed to sed ${x}"

	done

	# Apply this patch for Gentoo/FreeBSD/SPARC64 to build correctly
	# from catalyst, then don't do anything else
	if use build; then
		cd "${WORKDIR}"
		epatch "${FILESDIR}/freebsd-sources-6.2-sparc64.patch"
		return 0
	fi

	if [[ ${CTARGET} == ${CHOST} ]]; then
		ln -s "/usr/src/sys-${RV}" "${WORKDIR}/sys"
	else
		sed -i -e "s:/usr/include:/usr/${CTARGET}/usr/include:g" \
			"${S}/libc/"{yp,rpc}"/Makefile.inc"
	fi

	[[ -n $(install --version 2> /dev/null | grep GNU) ]] && \
		sed -i -e 's:${INSTALL} -C:${INSTALL}:' "${WORKDIR}/include/Makefile"

	# Let arch-specific includes to be found
	local machine
	machine=$(tc-arch-kernel ${CTARGET})
	ln -s "${WORKDIR}/sys/${machine}/include" "${WORKDIR}/include/machine"

	use bootstrap && dummy_mk libstand
}

src_compile() {
	cd "${WORKDIR}/include"
	$(freebsd_get_bmake) CC=$(tc-getCC) || die "make include failed"

	use crosscompile_opts_headers-only && return 0

	# Don't use ssp until properly fixed
	append-flags $(test-flags -fno-stack-protector -fno-stack-protector-all)

	strip-flags
	if [[ ${CTARGET} != ${CHOST} ]]; then
		export YACC='yacc -by'
		CHOST=${CTARGET} tc-export CC LD CXX

		local machine
		machine=$(tc-arch-kernel ${CTARGET})

		local csudir
		if [[ -d "${S}/csu/${machine}-elf" ]]; then
			csudir="${S}/csu/${machine}-elf"
		else
			csudir="${S}/csu/${machine}"
		fi
		cd "${csudir}"
		$(freebsd_get_bmake) ${mymakeopts} || die "make csu failed"

		append-flags "-isystem /usr/${CTARGET}/usr/include"
		append-flags "-B ${csudir}"
		append-ldflags "-B ${csudir}"
		cd "${S}/libc"
		$(freebsd_get_bmake) ${mymakeopts} || die "make libc failed"

		append-flags "-isystem ${WORKDIR}/lib/msun/${machine/i386/i387}"
		cd "${S}/msun"
		$(freebsd_get_bmake) ${mymakeopts} || die "make libc failed"
	else
		# Forces to use the local copy of headers as they might be outdated in
		# the system
		append-flags "-isystem '${WORKDIR}/sys' -isystem '${WORKDIR}/include'"

		cd "${S}"
		NOFLAGSTRIP=yes freebsd_src_compile
	fi
}

src_install() {
	cd "${WORKDIR}/include"

	[[ ${CTARGET} == ${CHOST} ]] \
		&& INCLUDEDIR="/usr/include" \
		|| INCLUDEDIR="/usr/${CTARGET}/usr/include"

	einfo "Installing for ${CTARGET} in ${CHOST}.."

	dodir "${INCLUDEDIR}"
	$(freebsd_get_bmake) installincludes \
		MACHINE=$(tc-arch-kernel) \
		DESTDIR="${D}" INCLUDEDIR="${INCLUDEDIR}" || die "Install failed"

	# Install math.h when crosscompiling, at this point
	if [[ ${CHOST} != ${CTARGET} ]]; then
		insinto "/usr/${CTARGET}/usr/include"
		doins "${S}/msun/src/math.h"
	fi

	use crosscompile_opts_headers-only && return 0

	if [[ ${CTARGET} != ${CHOST} ]]; then
		local csudir
		if [[ -d "${S}/csu/$(tc-arch-kernel ${CTARGET})-elf" ]]; then
			csudir="${S}/csu/$(tc-arch-kernel ${CTARGET})-elf"
		else
			csudir="${S}/csu/$(tc-arch-kernel ${CTARGET})"
		fi
		cd "${csudir}"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install \
			FILESDIR="/usr/${CTARGET}/usr/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install csu failed"

		cd "${S}/libc"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install failed"

		cd "${S}/msun"
		$(freebsd_get_bmake) ${mymakeopts} DESTDIR="${D}" install NO_MAN= \
			INCLUDEDIR="/usr/${CTARGET}/usr/include" \
			SHLIBDIR="/usr/${CTARGET}/lib" LIBDIR="/usr/${CTARGET}/usr/lib" || die "Install failed"

		dosym "usr/include" "/usr/${CTARGET}/sys-include"
	else
		cd "${S}"
		mkinstall || die "Install failed"
	fi

	# Don't install the rest of the configuration files if crosscompiling
	[[ ${CTARGET} != ${CHOST} ]] && return 0

	# Compatibility symlinks to run FreeBSD 5.x binaries (ABI is mostly
	# identical, remove when problems will actually happen)
	dosym /lib/libc.so.6 /usr/lib/libc.so.5
	dosym /lib/libm.so.4 /usr/lib/libm.so.3

	# install libstand files
	dodir /usr/include/libstand
	insinto /usr/include/libstand
	doins "${S}"/libstand/*.h

	cd "${WORKDIR}/etc/"
	insinto /etc
	doins auth.conf nls.alias mac.conf netconfig

	# Install ttys file
	doins "etc.$(tc-arch-kernel)"/*

	# Install a default libmap.conf that uses libthr by default
	doins "${FILESDIR}"/libmap.conf

	dodir /etc/sandbox.d
	cat - > "${D}"/etc/sandbox.d/00freebsd <<EOF
# /dev/crypto is used mostly by OpenSSL on *BSD platforms
# leave it available as packages might use OpenSSL commands
# during compile or install phase.
SANDBOX_PREDICT="/dev/crypto"
EOF
}
