# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/cpufreqd/cpufreqd-2.0.0_pre1-r1.ebuild,v 1.2 2005/10/17 09:11:20 brix Exp $

inherit eutils

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

NVCLOCK_VERSION="0.8b"

DESCRIPTION="CPU Frequency Daemon"
HOMEPAGE="http://cpufreqd.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
		nvidea? ( http://www.linuxhardware.org/nvclock/nvclock${NVCLOCK_VERSION}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="acpi apm lm_sensors nforce2 nvidea pmu"
DEPEND="sys-power/cpufrequtils
		lm_sensors? ( sys-apps/lm_sensors )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	if use nvidea; then
		cd ${WORKDIR}/nvclock${NVCLOCK_VERSION}
		epatch ${FILESDIR}/nvclock${NVCLOCK_VERSION}-fd.patch
	fi

	cd ${S}
	epatch ${FILESDIR}/${MY_P}-nv.patch
}

src_compile() {
	local config

	if use nvidea; then
		cd ${WORKDIR}/nvclock${NVCLOCK_VERSION}
		econf \
			--disable-gtk \
			--disable-qt \
			--disable-nvcontrol \
			|| die "econf nvclock failed"
		emake -j1 || die "emake nvclock failed"
		config="--enable-nvclock=${WORKDIR}/nvclock${NVCLOCK_VERSION}"
	fi

	cd ${S}
	econf \
		$(use_enable acpi) \
		$(use_enable apm) \
		$(use_enable lm_sensors sensors) \
		$(use_enable nforce2) \
		$(use_enable pmu) \
		${config} \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO

	newinitd ${FILESDIR}/${P}-init.d ${PN}

	insinto /etc
	newins ${FILESDIR}/${MY_P}-cpufreqd.conf cpufreqd.conf
}

pkg_postinst() {
	einfo
	einfo "Significant changes have happened since the 1.x releases, including"
	einfo "changes in the configuration file format."
	einfo
	einfo "Make sure you update your /etc/cpufreqd.conf file before starting"
	einfo "${PN}. You can use 'etc-update' to accomplish this:"
	einfo
	einfo "  # etc-update"
	einfo
}
