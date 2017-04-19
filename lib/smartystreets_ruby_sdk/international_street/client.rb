require_relative '../request'

module InternationalStreet
  # It is recommended to instantiate this class using ClientBuilder.build_international_street_api_client()
  class Client
    def initialize(sender, serializer)
      @sender = sender
      @serializer = serializer
    end

    # Sends a Lookup object to the International Street API and stores the result in the Lookup's result field.
    def send(lookup)
      lookup.ensure_enough_info
      request = build_request(lookup)

      response = @sender.send(request)

      candidates = convert_candidates(@serializer.deserialize(response.payload))
      lookup.result = candidates
    end

    def build_request(lookup)
      request = Request.new

      add_parameter(request, 'country', lookup.country)
      add_parameter(request, 'geocode', lookup.geocode.to_s)
      add_parameter(request, 'language', lookup.language)
      add_parameter(request, 'freeform', lookup.freeform)
      add_parameter(request, 'address1', lookup.address1)
      add_parameter(request, 'address2', lookup.address2)
      add_parameter(request, 'address3', lookup.address3)
      add_parameter(request, 'address4', lookup.address4)
      add_parameter(request, 'organization', lookup.organization)
      add_parameter(request, 'locality', lookup.locality)
      add_parameter(request, 'administrative_area', lookup.administrative_area)
      add_parameter(request, 'postal_code', lookup.postal_code)

      request
    end

    def add_parameter(request, key, value)
      request.parameters[key] = value unless value.nil? or value.empty?
    end

    def convert_candidates(raw_candidates)
      candidates = []

      raw_candidates.each do |candidate|
        candidates.push(Candidate.new(candidate))
      end

      candidates
    end
  end
end