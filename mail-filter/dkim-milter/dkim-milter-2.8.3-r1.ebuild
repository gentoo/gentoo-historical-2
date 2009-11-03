# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dkim-milter/dkim-milter-2.8.3-r1.ebuild,v 1.2 2009/11/03 17:31:26 armin76 Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A milter-based application to provide DomainKeys Identified Mail (DKIM) service"
HOMEPAGE="http://sourceforge.net/projects/dkim-milter/"
SRC_URI="mirror://sourceforge/dkim-milter/${P}.tar.gz"

LICENSE="Sendmail-Open-Source"
SLOT="0"
KEYWORDS="~amd64 ~ia64 x86"
IUSE="ipv6 diffheaders"

DEPEND="dev-libs/openssl
	>=sys-libs/db-3.2
	|| ( mail-filter/libmilter mail-mta/sendmail )
	diffheaders? ( dev-libs/tre )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup milter
	# mail-milter/spamass-milter creates milter user with this home directory
	# For consistency reasons, milter user must be created here with this home directory
	# even though this package doesn't need a home directory for this user (#280571)
	enewuser milter -1 -1 /var/lib/milter milter
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-build-system.patch

	cp site.config.m4.dist devtools/Site/site.config.m4 || \
		die "failed to copy site.config.m4"
	epatch "${FILESDIR}"/${P}-gentoo.patch

	local CC="$(tc-getCC)"
	local ENVDEF=""
	use ipv6 && ENVDEF="${ENVDEF} -DNETINET6"
	sed -i -e "s:@@CC@@:${CC}:" \
		-e "s:@@CFLAGS@@:${CFLAGS}:" \
		-e "s:@@LDFLAGS@@:${LDFLAGS}:" \
		-e "s:@@ENVDEF@@:${ENVDEF}:" \
		-e "s:@@LIBDIR@@:/usr/$(get_libdir):" \
		devtools/Site/site.config.m4

	if use diffheaders ; then
		epatch "${FILESDIR}/${PN}-diffheaders.patch"

		sed -i -e 's/^dnl \(APPENDDEF.*-D_FFR_DIFFHEADERS.*\)/\1/' \
			devtools/Site/site.config.m4
	fi
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_test() {
	emake -j1 OPTIONS=check || die "emake check failed"
}

src_install() {
	# no other program need to read from here
	dodir /etc/mail/dkim-filter
	fowners milter:milter /etc/mail/dkim-filter
	fperms 700 /etc/mail/dkim-filter

	insinto /etc/mail/dkim-filter
	newins dkim-filter/dkim-filter.conf.sample dkim-filter.conf

	newinitd "${FILESDIR}/dkim-filter.init" dkim-filter \
		|| die "newinitd failed"
	sed -i -e s:bin/dkim-filter:sbin/dkim-filter: "${D}/etc/init.d/dkim-filter" \
		|| die 'failed to correct dkim-filter path'

	# prepare directory for .pid, .sock and .stats files
	dodir /var/run/dkim-filter
	fowners milter:milter /var/run/dkim-filter

	dodir /usr/bin /usr/sbin
	emake -j1 DESTDIR="${D}" \
		SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
		install || die "make install failed"

	# man build is broken; do man page installation by hand
	doman */*.{3,5,8} || die "failed to install man pages"

	# some people like docs
	dodoc README RELEASE_NOTES *.txt &&
		dohtml -r libdkim/docs/* ||
		die "failed to install docs"
}

pkg_postinst() {
	elog "If you want to sign your mail messages, you will have to run"
	elog "  emerge --config ${CATEGORY}/${PN}"
	elog "It will help you create your key and give you hints on how"
	elog "to configure your DNS and MTA."

	ewarn "Make sure your MTA has r/w access to the socket file."
	ewarn "This can be done either by setting UMask to 002 and adding MTA's user"
	ewarn "to milter group or you can simply set UMask to 000."
}

pkg_config() {
	local selector keysize pubkey

	read -p "Enter the selector name (default ${HOSTNAME}): " selector
	[[ -n "${selector}" ]] || selector=${HOSTNAME}
	if [[ -z "${selector}" ]]; then
		eerror "Oddly enough, you don't have a HOSTNAME."
		return 1
	fi
	if [[ -f "${ROOT}"etc/mail/dkim-filter/${selector}.private ]]; then
		ewarn "The private key for this selector already exists."
	else
		einfo "Select the size of private key:"
		einfo "  [1] 512 bits"
		einfo "  [2] 1024 bits"
		while read -n 1 -s -p "  Press 1 or 2 on the keyboard to select the key size " keysize ; do
			[[ "${keysize}" == "1" || "${keysize}" == "2" ]] && echo && break
		done
		case ${keysize} in
			1) keysize=512 ;;
			*) keysize=1024 ;;
		esac

		# generate the private and public keys
		dkim-genkey -b ${keysize} -D "${ROOT}"etc/mail/dkim-filter/ \
			-s ${selector} && \
			chown milter:milter \
			"${ROOT}"etc/mail/dkim-filter/"${selector}".private || \
				{ eerror "Failed to create private and public keys." ; return 1; }
	fi

	# dkim-filter selector configuration
	echo
	einfo "Make sure you have the following settings in your dkim-filter.conf:"
	einfo "  Keyfile /etc/mail/dkim-filter/${selector}.private"
	einfo "  Selector ${selector}"

	# MTA configuration
	echo
	einfo "If you are using Postfix, add following lines to your main.cf:"
	einfo "  smtpd_milters     = unix:/var/run/dkim-filter/dkim-filter.sock"
	einfo "  non_smtpd_milters = unix:/var/run/dkim-filter/dkim-filter.sock"

	# DNS configuration
	einfo "After you configured your MTA, publish your key by adding this TXT record to your domain:"
	cat "${ROOT}"etc/mail/dkim-filter/${selector}.txt
	einfo "t=y signifies you only test the DKIM on your domain. See following page for the complete list of tags:"
	einfo "  http://www.dkim.org/specs/rfc4871-dkimbase.html#key-text"
	einfo
	einfo "Also look at the draft ASP http://www.dkim.org/specs/draft-ietf-dkim-ssp-03.html"
}
