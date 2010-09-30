# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nvidia-cuda-sdk/nvidia-cuda-sdk-2.2.ebuild,v 1.6 2010/09/30 08:59:17 spock Exp $

inherit eutils toolchain-funcs

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="http://developer.nvidia.com/cuda"

CUDA_V=${PV//./_}

SRC_URI="http://developer.download.nvidia.com/compute/cuda/${CUDA_V}/sdk/cudasdk_${PV}_linux.run"
LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug emulation"

RDEPEND=">=dev-util/nvidia-cuda-toolkit-2.2
	>=x11-drivers/nvidia-drivers-180.22
	media-libs/freeglut"
DEPEND="${RDEPEND}
	<sys-devel/gcc-4.4"

S="${WORKDIR}"

RESTRICT="binchecks"

pkg_setup() {
	if [ "$(gcc-major-version)" == "4" -a $(gcc-minor-version) -ge 4 ]; then
		eerror "This package requires <=sys-devel/gcc-4.3 to build sucessfully."
		eerror "Please use gcc-config to switch to a compatible GCC version."
		die "<=sys-devel/gcc-4.3 required"
	fi
}

src_unpack() {
	unpack_makeself
	cd "${S}"
	sed -i -e 's:CUDA_INSTALL_PATH ?= .*:CUDA_INSTALL_PATH ?= /opt/cuda:' sdk/common/common.mk
}

src_compile() {
	local myopts=""

	if use emulation; then
		myopts="emu=1"
	fi

	if use debug; then
		myopts="${myopts} dbg=1"
	fi

	cd "${S}/sdk"
	emake cuda-install=/opt/cuda ${myopts} || die
}

src_install() {
	cd "${S}/sdk"

	for f in $(find .); do
		local t="$(dirname ${f})"
		if [[ "${t/obj\/}" != "${t}" || "${t##*.}" == "a" ]]; then
			continue
		fi

		if [[ -x "${f}" && ! -d "${f}" ]]; then
			exeinto "/opt/cuda/sdk/$(dirname ${f})"
			doexe "${f}"
		else
			insinto "/opt/cuda/sdk/$(dirname ${f})"
			doins "${f}"
		fi
	done
}
