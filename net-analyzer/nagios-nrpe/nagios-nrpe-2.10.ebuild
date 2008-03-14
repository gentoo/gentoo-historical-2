# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-nrpe/nagios-nrpe-2.10.ebuild,v 1.5 2008/03/14 11:58:40 caleb Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Nagios $PV NRPE - Nagios Remote Plugin Executor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/nrpe-${PV}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha amd64 ~ppc ppc64 sparc x86"

IUSE="ssl command-args"
DEPEND=">=net-analyzer/nagios-plugins-1.3.0
	ssl? ( dev-libs/openssl )"
S="${WORKDIR}/nrpe-${PV}"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /dev/null nagios
}

src_compile() {
	local myconf

	myconf="${myconf} $(use_enable ssl) \
					  $(use_enable command-args)"

	# Generate the dh.h header file for better security (2005 Mar 20 eldad)
	if useq ssl ; then
		openssl dhparam -C 512 | sed -n '1,/BEGIN DH PARAMETERS/p' | grep -v "BEGIN DH PARAMETERS" > "${S}"/src/dh.h
	fi

	econf ${myconf} \
		--host=${CHOST} \
		--prefix=/usr/nagios \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nrpe-user=nagios \
		--with-nrpe-grp=nagios || die "econf failed"
	emake all || die "make failed"
	# Add nifty nrpe check tool
	cd contrib
	$(tc-getCC) ${CFLAGS} -o nrpe_check_control	nrpe_check_control.c
}

src_install() {
	dodoc LEGAL Changelog README SECURITY README.SSL \
		contrib/README.nrpe_check_control

	insinto /etc/nagios
	newins "${S}"/sample-config/nrpe.cfg nrpe.cfg
	fowners root:nagios /etc/nagios/nrpe.cfg
	fperms 0640 /etc/nagios/nrpe.cfg

	exeopts -m0750 -o nagios -g nagios
	exeinto /usr/nagios/bin
	doexe src/nrpe

	exeopts -m0750 -o nagios -g nagios
	exeinto /usr/nagios/libexec
	doexe src/check_nrpe contrib/nrpe_check_control

	newinitd "${FILESDIR}"/nrpe nrpe

	cat << EOF > "${T}"/55-nagios-nrpe-revdep
SEARCH_DIRS="/usr/nagios/bin /usr/nagios/libexec"
EOF

	insinto /etc/revdep-rebuild
	doins "${T}"/55-nagios-nrpe-revdep
}

pkg_postinst() {
	einfo
	einfo "If you are using the nrpe daemon, remember to edit"
	einfo "the config file /etc/nagios/nrpe.cfg"
	einfo

	if useq command-args ; then
		ewarn "You have enabled command-args for NRPE. This enables"
		ewarn "the ability for clients to supply arguments to commands"
		ewarn "which should be run. "
		ewarn "THIS IS CONSIDERED A SECURITY RISK!"
		ewarn "Please read /usr/share/doc/${PF}/SECURITY.bz2 for more info"
	fi
}
